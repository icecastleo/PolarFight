//
//  ParalysisMeleeAttackSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/24.
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
    component.cdTime = 3;
    component.totalTime = 3;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:100];
    [event.sideEffects addObject:sideEffect];
}

@end
