//
//  DeadBomb.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/27.
//
//

#import "DeadBomb.h"
#import "DamageEvent.h"
#import "AttackEvent.h"
#import "DefenderComponent.h"

@implementation DeadBomb

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    
    DefenderComponent *defender = (DefenderComponent *)[event.defender getComponentOfClass:[DefenderComponent class]];
    DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:1000*event.attack.attack.value damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:entity];
    [defender.damageEventQueue addObject:damageEvent];
    
    DefenderComponent *selfDefender = (DefenderComponent *)[event.attacker getComponentOfClass:[DefenderComponent class]];
    DamageEvent *damageEvent2 = [[DamageEvent alloc] initWithSender:self.owner damage:1000*event.attack.attack.value damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:self.owner];
    [selfDefender.damageEventQueue addObject:damageEvent2];
}

@end
