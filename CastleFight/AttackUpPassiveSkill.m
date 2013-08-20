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

@implementation AttackUpPassiveSkill

-(void)checkEvent:(EntityEvent)eventType  Message:(id)message {
    if (eventType != kEventReceiveDamage) {
        return;
    }
    [self activeEffect];
}

-(void)activeEffect {
    
    AttackBonusMultiplierComponent *component = (AttackBonusMultiplierComponent *)[self.owner getComponentOfName:[AttackBonusMultiplierComponent name]];
    
    if (component) {
        return;
    }

    AttackerComponent *attacker = (AttackerComponent *)[self.owner getComponentOfName:[AttackerComponent name]];
    
    component = [[AttackBonusMultiplierComponent alloc] initWithAttribute:attacker.attack andBonus:2];
    component.cdTime = 0;
    component.totalTime = 3;
    [self.owner addComponent:component];
}

@end
