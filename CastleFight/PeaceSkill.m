//
//  PeaceSkill.m
//  CastleFight
//
//  Created by  DAN on 13/6/3.
//
//

#import "PeaceSkill.h"
#import "ParalysisComponent.h"
#import "MoveComponent.h"

@interface PeaceSkill()
@property (nonatomic,readonly) BOOL isActivated;
@end

@implementation PeaceSkill

-(void)checkEvent:(EventType)eventType {
    switch (eventType) {
        case KEventDead:
            _isActivated = YES;
            break;
            
        default:
            break;
    }
}

-(void)activeEffect {
    
    if (!self.isActivated) {
        return;
    }
    NSArray *entities = [self.owner getAllEntitiesPosessingComponentOfClass:[MoveComponent class]];
    
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
