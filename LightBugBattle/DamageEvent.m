//
//  DamageEvent.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/19.
//
//

#import "DamageEvent.h"
#import "Character.h"

@implementation DamageEvent
//@dynamic damage;

-(id)initWithBaseDamage:(int)aNumber damageType:(DamageType)aType damager:(Character*)aCharacter {
    if(self = [super init]) {
        _baseDamage = aNumber;
        _type = aType;
        _damager = aCharacter;
        bonus = 0;
        multiplier = 1;
    }
    return self;
}

-(void)addDamage:(float)aBonus {
    bonus += aBonus;
}

-(void)subtractDamage:(float)aBonus {
    bonus -= aBonus;
}

-(void)addMultiplier:(float)aMultiplier {
    multiplier *= aMultiplier;
}

-(void)subtractMultiplier:(float)aMultiplier {
    multiplier /= aMultiplier;
}

-(int)damage {
    if (multiplier == 0) {
        return 0;
    }
    return MAX(1, _baseDamage * multiplier + bonus);
}

-(Damage *)convertToDamage {
    Damage *damage = [[Damage alloc] initWithValue:[self damage] damageType:_type damager:_damager];
    damage.location = _location;
    damage.knockOutPower = _knockOutPower;
    damage.knouckOutCollision = _knouckOutCollision;
    return damage;
}

@end
