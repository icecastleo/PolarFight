//
//  ParalysisMeleeAttackSkill.m
//  CastleFight
//
//  Created by  DAN on 13/5/24.
//
//

#import "ParalysisMeleeAttackSkill.h"
#import "SideEffect.h"
#import "ParalysisComponent.h"
#import "AttackEvent.h"
#import "DamageEvent.h"

@implementation ParalysisMeleeAttackSkill

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    ParalysisComponent *component = [[ParalysisComponent alloc] init];
    component.cdTime = 1;
    component.totalTime = 100;
//    DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:0 damageType:kDamageTypePoison damageSource:kDamageSourceMelee receiver:entity];
//    component.event = damageEvent;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:100];
    [event.sideEffects addObject:sideEffect];
}

@end
