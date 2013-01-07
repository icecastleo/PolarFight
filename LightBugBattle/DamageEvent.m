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
        _bonus = 0;
        _multiplier = 1;
    }
    return self;
}

-(int)damage {
    if (_multiplier == 0) {
        return 0;
    }
    
    return MAX(1, _baseDamage * _multiplier + _bonus);
}

-(Damage *)convertToDamage {
    return [[Damage alloc] initWithValue:[self damage] damageType:_type damager:_damager];
}

@end
