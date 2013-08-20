//
//  PeaceSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/3.
//
//

#import "PeaceSkill.h"
#import "ParalysisComponent.h"
#import "MoveComponent.h"

@implementation PeaceSkill

-(void)checkEvent:(EntityEvent)eventType  Message:(id)message {
    if (eventType != kEntityEventDead) {
        return;
    }
    [self activeEffect];
}

-(void)activeEffect {
    
    NSArray *entities = [self.owner getAllEntitiesPosessingComponentOfName:[MoveComponent name]];
    
    for (Entity *entity in entities) {
        if (entity.eid == self.owner.eid) {
            continue;
        }
        ParalysisComponent *component = [[ParalysisComponent alloc] init];
        component.cdTime = 1;
        component.totalTime = 3;
        [entity addComponent:component];
    }
}

@end
