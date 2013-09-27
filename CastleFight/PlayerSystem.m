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
    NSArray * entities = [self.entityManager getAllEntitiesPosessingComponentOfName:[PlayerComponent name]];
    
    for (Entity *entity in entities) {
        PlayerComponent * player = (PlayerComponent *)[entity getComponentOfName:[PlayerComponent name]];
        
//        player.delta += delta;
//        
//        if (player.delta >= player.interval) {
//            player.delta -= player.interval;
//            player.food += player.foodRate;
//            player.mana += player.manaRate;
//        }
        
//        if (player.mana > kManaBarFullValue) {
//            TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
//            if (team.team == 1) {
//                //user
//                CCLOG(@"Mana > 200! Summon Hero");
//            } else {
//                CCLOG(@"Mana > 200! Summon Boss");
//            }
//            player.mana -= kManaBarFullValue;
//            [self.entityFactory createCharacter:@"203" level:10 forTeam:team.team];
//        }
        
        NSMutableArray *summonComponents = [[NSMutableArray alloc] init];
        // Summon entities
//        NSMutableArray *summonComponents = player.summonComponents;
        
        // Summon heros
        [summonComponents addObjectsFromArray:player.battleTeam];
        
        for (SummonComponent *summon in summonComponents) {
            if (summon.summon && summon.canSummon) {
                summon.summon = NO;
                                
                TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
                
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
