//
//  AttackUpPassiveSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/6.
//
//

#import "AttackUpPassiveSkill.h"
#import "AttackerComponent.h"

@interface AttackUpPassiveSkill()
@property (nonatomic,readonly) BOOL isActivated;
@end

@implementation AttackUpPassiveSkill

-(void)checkEvent:(EventType)eventType {
    switch (eventType) {
        case kEventReceiveDamage:
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
    
    AttackerComponent *attacker = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]]; 
    
}
@end
