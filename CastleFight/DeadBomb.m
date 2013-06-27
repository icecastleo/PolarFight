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

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@30,kRangeKeyRadius,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 1.5;
    }
    return self;
}

-(void)activeEffect {
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:entity];
        //        event.knockOutPower = 25;
        //        event.knouckOutCollision = YES;
        [self sideEffectWithEvent:event Entity:entity];
        [attack.attackEventQueue addObject:event];
    }
}

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    
    DefenderComponent *defender = (DefenderComponent *)[event.defender getComponentOfClass:[DefenderComponent class]];
    DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:1000*event.attack.attack.value damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:entity];
    [defender.damageEventQueue addObject:damageEvent];
    
    DefenderComponent *selfDefender = (DefenderComponent *)[event.attacker getComponentOfClass:[DefenderComponent class]];
    DamageEvent *damageEvent2 = [[DamageEvent alloc] initWithSender:self.owner damage:1000*event.attack.attack.value damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:self.owner];
    [selfDefender.damageEventQueue addObject:damageEvent2];
}

@end
