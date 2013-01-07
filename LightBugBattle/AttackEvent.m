//
//  Attack.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/4.
//
//

#import "AttackEvent.h"
#import "Character.h"
#import "Attribute.h"

@implementation AttackEvent

-(id)initWithAttacker:(Character *)anAttacker attackType:(AttackType)aType defender:(Character*)aDefender {
    if(self = [super init]) {
        _attacker = anAttacker;
        _defender = aDefender;
        _type = aType;
        _bonus = 0;
        _multiplier = 1;
    }
    return self;
}

-(int)attack {
    Attribute *attack = [_attacker getAttribute:kCharacterAttributeAttack];
    
    NSAssert(attack != nil, @"How can you let a character without attack attribute to attack?");

    return attack.value;
}

-(int)getDamage {
    return (self.attack + _bonus) * _multiplier;
}

-(DamageEvent*)convertToDamageEvent {
    return [[DamageEvent alloc] initWithBaseDamage:[self getDamage] damageType:kDamageTypeAttack damager:_attacker];
}

@end
