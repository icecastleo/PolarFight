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
    [self processComponent:delta className:[PoisonComponent class]];
    [self processComponent:delta className:[ParalysisComponent class]];
    [self processComponent:delta className:[AttackBonusMultiplierComponent class]];
    [self processComponent:delta className:[SpeedBonusAddComponent class]];
    [self processComponent:delta className:[AuraComponent class]];
    [self processComponent:delta className:[StealthComponent class]];
}

-(void)processComponent:(float)delta  className:(Class)className {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:className];
    
    for (Entity *entity in entities) {
        StateComponent *stateComponent = (StateComponent *)[entity getComponentOfClass:className];
        stateComponent.currentTime += delta;
        
        if (stateComponent.totalTime >= 0) {
            if (stateComponent.currentTime >= stateComponent.cdTime) {
                stateComponent.currentTime -= stateComponent.cdTime;
//                NSLog(@"stateComponent.currentTime > cdTime");
                DefenderComponent *defendCom = (DefenderComponent *)[entity getComponentOfClass:[DefenderComponent class]];
                if (stateComponent.event) {
                    [defendCom.damageEventQueue addObject:stateComponent.event];
                }
            [stateComponent process];
            }
        }else {
            [entity removeComponent:[stateComponent class]];
            NSLog(@"remove stateComponent");
        }
        stateComponent.totalTime -= delta;
    }
}

@end
