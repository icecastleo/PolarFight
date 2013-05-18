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

@implementation PlayerSystem

-(void)update:(float)delta {
    NSArray * entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[PlayerComponent class]];
    
    for (Entity * entity in entities) {
        PlayerComponent * player = (PlayerComponent *)[entity getComponentOfClass:[PlayerComponent class]];
        
        player.delta += delta;
        
        if (player.delta >= player.interval) {
            player.delta -= player.interval;
            player.food += player.foodRate;
        }
        
        // Summon entity
        NSMutableArray *summonComponents = player.summonComponents;
        
        for (SummonComponent *summon in summonComponents) {
            if (summon.summon && summon.canSummon) {
                summon.summon = NO;
                player.food -= summon.cost;
                
                TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
                
                CharacterInitData *data = summon.data;
                
                [self.entityFactory createCharacter:data.cid level:data.level forTeam:team.team];
                [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_unit_click.caf"];
                
                summon.currentCooldown = summon.cooldown;
                
                if (summon.menuItem) {
                    summon.menuItem.isEnabled = NO;
                    summon.menuItem.mask.visible = YES;
                    [summon.menuItem.timer runAction:[CCProgressFromTo actionWithDuration:summon.cooldown from:100 to:0]];
                }
            } else {
                summon.summon = NO;
                
                if (summon.currentCooldown > 0) {
                    summon.currentCooldown -= delta;
                }
                
                if (summon.menuItem) {
                    if (summon.menuItem.timer.numberOfRunningActions == 0) {
                        if (summon.isCostSufficient) {
                            summon.menuItem.isEnabled = YES;
                            summon.menuItem.mask.visible = NO;
                        } else {
                            summon.menuItem.isEnabled = NO;
                            summon.menuItem.mask.visible = YES;
                        }
                    }
                }
            }
        }
    }
}

@end
