//
//  PoisonMeleeAttackSkill.m
//  CastleFight
//
//  Created by  DAN on 13/5/24.
//
//

#import "PoisonMeleeAttackSkill.h"
#import "SideEffect.h"
#import "PoisonComponent.h"
#import "AttackEvent.h"
#import "DamageEvent.h"

@implementation PoisonMeleeAttackSkill

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    PoisonComponent *component = [[PoisonComponent alloc] init];
    component.cdTime = 1;
    component.totalTime = 100;
    DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:50 damageType:kDamageTypePoison damageSource:kDamageSourceMelee receiver:entity];
    component.event = damageEvent;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:50];
    [event.sideEffects addObject:sideEffect];
}

@end
