//
//  KnockOutSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/28.
//
//

#import "KnockOutSkill.h"
#import "KnockOutComponent.h"
#import "DamageEvent.h"
#import "SideEffect.h"
#import "AttackEvent.h"

@implementation KnockOutSkill

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    KnockOutComponent *component = [[KnockOutComponent alloc] init];
    component.cdTime = 0; // once only
    component.totalTime = 0;
    component.animationDuration = 0.5; //show time
    
    component.attack = event.attack.attack.value;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:100];
    [event.sideEffects addObject:sideEffect];
}

@end
