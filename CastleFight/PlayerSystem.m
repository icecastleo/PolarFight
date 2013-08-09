//
//  PlayerSystem.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "PlayerSystem.h"
#import "PlayerComponent.h"
#import "SummonComponent.h"
#import "TeamComponent.h"
#import "SimpleAudioEngine.h"
#import "ThreeLineMapLayer.h"

@implementation PlayerSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        NSAssert(entityFactory.mapLayer, @"This system need a map layer!");
    }
    return self;
}

-(void)update:(float)delta {
    NSArray * entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[PlayerComponent class]];
    
    for (Entity *entity in entities) {
        PlayerComponent * player = (PlayerComponent *)[entity getComponentOfClass:[PlayerComponent class]];
        
        player.delta += delta;
        
        if (player.delta >= player.interval) {
            player.delta -= player.interval;
            player.food += player.foodRate;
            player.mana += player.manaRate;
        }
        
        // Summon entities
        NSMutableArray *summonComponents = player.summonComponents;
        
        // Summon heros
        [summonComponents addObjectsFromArray:player.battleTeam];
        
        for (SummonComponent *summon in summonComponents) {
            
            if (summon.summon && summon.canSummon) {
                summon.summon = NO;
                
//                // TODO: Maybe another solution!
//                if ([self.entityFactory.mapLayer isKindOfClass:[ThreeLineMapLayer class]]) {
//                    ThreeLineMapLayer *map = (ThreeLineMapLayer *)self.entityFactory.mapLayer;
//
//                    if (map.isSelectLineOccupied) {
//                        return;
//                    }
//                }
                
                TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
                
                CharacterInitData *data = summon.data;
                
                [self.entityFactory createCharacter:data.cid level:data.level forTeam:team.team];
                [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_unit_click.caf"];
                
                [summon finishSummon];
            
            } else {
                summon.summon = NO;
                
                if (summon.currentCooldown > 0) {
                    summon.currentCooldown -= delta;
                }
                
                [summon updateSummon];
            }
        }
    }
}

@end
