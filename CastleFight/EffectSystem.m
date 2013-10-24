//
//  EffectSystem.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/23.
//
//

#import "EffectSystem.h"
#import "StateComponent.h"
#import "PoisonComponent.h"
#import "DefenderComponent.h"
#import "ParalysisComponent.h"
#import "AttackBonusMultiplierComponent.h"
#import "SpeedBonusAddComponent.h"
#import "AuraComponent.h"
#import "StealthComponent.h"

@implementation EffectSystem

-(void)update:(float)delta {
    [self processComponent:delta className:[PoisonComponent name]];
    [self processComponent:delta className:[ParalysisComponent name]];
    [self processComponent:delta className:[AttackBonusMultiplierComponent name]];
    [self processComponent:delta className:[SpeedBonusAddComponent name]];
    [self processComponent:delta className:[AuraComponent name]];
    [self processComponent:delta className:[StealthComponent name]];
}

-(void)processComponent:(float)delta className:(NSString *)className {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfName:className];
    
    for (Entity *entity in entities) {
        StateComponent *stateComponent = (StateComponent *)[entity getComponentOfName:className];
        stateComponent.currentTime += delta;
        
        if (stateComponent.totalTime >= 0) {
            if (stateComponent.currentTime >= stateComponent.cdTime) {
                stateComponent.currentTime -= stateComponent.cdTime;
//                NSLog(@"stateComponent.currentTime > cdTime");
                DefenderComponent *defendCom = (DefenderComponent *)[entity getComponentOfName:[DefenderComponent name]];
                if (stateComponent.event) {
                    [defendCom.damageEventQueue addObject:stateComponent.event];
                }
                if ([stateComponent respondsToSelector:@selector(process)]) {
                    [stateComponent process];
                }
            }
        } else {
            [entity removeComponent:[[stateComponent class] name]];
            NSLog(@"remove stateComponent");
        }
        stateComponent.totalTime -= delta;
    }
}

@end
