//
//  SlowlyHealSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/27.
//
//

#import "SlowlyHealSkill.h"
#import "SideEffect.h"
#import "PoisonComponent.h"
#import "AttackEvent.h"
#import "DamageEvent.h"

@implementation SlowlyHealSkill

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    PoisonComponent *component = [[PoisonComponent alloc] init];
    component.cdTime = 1;
    component.totalTime = 100;
    DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:-10*event.attack.attack.value damageType:kDamageTypePoison damageSource:kDamageSourceMelee receiver:entity];
    damageEvent.isCustomDamage = YES;
    component.event = damageEvent;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:50];
    [event.sideEffects addObject:sideEffect];
}

@end
