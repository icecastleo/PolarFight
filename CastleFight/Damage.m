//
//  Damage.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/24.
//
//

#import "Damage.h"
#import "Character.h"

@implementation Damage

-(id)initWithValue:(int)aNumber damageType:(DamageType)aType damageSource:(DamageSource)aSource damager:(Character*)aCharacter {
    if (self = [super init]) {
        _value = aNumber;
        _type = aType;
        _source = aSource;
        _damager = aCharacter;
    }
    return self;
}

@end
