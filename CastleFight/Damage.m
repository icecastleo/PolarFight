//
//  Damage.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/24.
//
//

#import "Damage.h"

@implementation Damage

-(id)initWithSender:(Entity *)sender damage:(int)damage damageType:(DamageType)type damageSource:(DamageSource)source {
    if (self = [super init]) {
        _sender = sender;
        _damage = damage;
        _type = type;
        _source = source;
    }
    return self;
}

@end
