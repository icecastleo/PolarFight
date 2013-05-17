//
//  DamageEvent.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/19.
//
//

#import "DamageEvent.h"
#import "DefenderComponent.h"

@implementation DamageEvent

-(id)initWithSender:(Entity *)sender damage:(int)damage damageType:(DamageType)type damageSource:(DamageSource)source receiver:(Entity *)receiver {
    if(self = [super init]) {
        NSAssert([receiver getComponentOfClass:[DefenderComponent class]] != nil, @"Invalid defender!");
        
        _sender = sender;
        _baseDamage = damage;
        _type = type;
        _source = source;
        _receiver = receiver;
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
    return MAX(1, _baseDamage * multiplier + bonus);
}

-(Damage *)convertToDamage {
    Damage *damage = [[Damage alloc] initWithSender:_sender damage:[self damage] damageType:_type damageSource:_source];
    damage.position = _position;
    damage.knockOutPower = _knockOutPower;
    damage.knouckOutCollision = _knouckOutCollision;
    return damage;
}

@end
