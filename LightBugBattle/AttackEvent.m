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
        bonus = 0;
        multiplier = 1;
        
        _location = _attacker.position;
    }
    return self;
}

-(int)attack {
    Attribute *attack = [_attacker getAttribute:kCharacterAttributeAttack];
    
    NSAssert(attack != nil, @"How can you let a character without attack attribute to attack?");

    return attack.value;
}

-(void)addAttack:(float)aBonus {
    bonus += aBonus;
}

-(void)subtractAttack:(float)aBonus {
    bonus -= aBonus;
}

-(void)addMultiplier:(float)aMultiplier {
    multiplier *= aMultiplier;
}

-(void)subtractMultiplier:(float)aMultiplier {
    multiplier /= aMultiplier;
}

-(int)getDamage {
    return (self.attack + bonus) * multiplier;
}

-(DamageEvent*)convertToDamageEvent {
    DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:[self getDamage] damageType:kDamageTypeAttack damager:_attacker];
    event.location = _location;
    event.knockOutPower = _knockOutPower;
    event.knouckOutCollision = _knouckOutCollision;
    return event;
}

@end
