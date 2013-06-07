//
//  AttackUpPassiveSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/6.
//
//

#import "AttackUpPassiveSkill.h"
#import "AttackerComponent.h"
#import "AttackBonusMultiplierComponent.h"

@interface AttackUpPassiveSkill()
@property (nonatomic) BOOL isActivated;
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
    
    AttackBonusMultiplierComponent *component = (AttackBonusMultiplierComponent *)[self.owner getComponentOfClass:[AttackBonusMultiplierComponent class]];
    
    if (component) {
        self.isActivated = NO;
        return;
    }

    AttackerComponent *attacker = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    component = [[AttackBonusMultiplierComponent alloc] initWithAttribute:attacker.attack andBonus:2];
    component.cdTime = 0;
    component.totalTime = 3;
    [self.owner addComponent:component];
}

@end
