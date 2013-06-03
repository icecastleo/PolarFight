//
//  DeadBomb.m
//  CastleFight
//
//  Created by  DAN on 13/5/27.
//
//

#import "DeadBomb.h"
#import "BombComponent.h"
#import "DamageEvent.h"
#import "SideEffect.h"
#import "AttackEvent.h"

@implementation DeadBomb

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    int startTime = 3;
    self.cooldown = startTime;
    event.isCustomDamage = YES;
    event.isIgnoreDefense = YES;
    event.customDamage = 0;
    
    BombComponent *component = [[BombComponent alloc] init];
    component.cdTime = startTime; // only once
    component.totalTime = startTime;
    DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:1000*event.attack.attack.value damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:entity];
    component.event = damageEvent;
    SideEffect *sideEffect1 = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:100]; // to enemy
    
    BombComponent *component2 = [[BombComponent alloc] init];
    component2.cdTime = startTime; // only once
    component2.totalTime = startTime;
    DamageEvent *damageEvent2 = [[DamageEvent alloc] initWithSender:self.owner damage:1000*event.attack.attack.value damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:self.owner];
    component2.event = damageEvent2;
    [self.owner addComponent:component2]; // to self
    
    [event.sideEffects addObject:sideEffect1];
}

@end
