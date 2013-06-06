//
//  BigPillowBomb.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/27.
//
//

#import "BigPillowBomb.h"
#import "BombComponent.h"
#import "DamageEvent.h"
#import "SideEffect.h"
#import "AttackEvent.h"

@implementation BigPillowBomb

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    BombComponent *component = [[BombComponent alloc] init];
    component.cdTime = 0; // only once
    component.totalTime = 0;
    DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:ceilf(event.attack.attack.value*2.0) damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:entity];
    component.event = damageEvent;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:30];
    [event.sideEffects addObject:sideEffect];
}

@end
