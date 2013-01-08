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
    multiplier *= multiplier;
}

-(void)subtractMultiplier:(float)aMultiplier {
    multiplier /= multiplier;
}

-(int)damage {
    if (multiplier == 0) {
        return 0;
    }
    return MAX(1, _baseDamage * multiplier + bonus);
}

-(Damage *)convertToDamage {
    return [[Damage alloc] initWithValue:[self damage] damageType:_type damager:_damager];
}

@end
