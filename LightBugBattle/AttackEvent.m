//
//  Attack.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/4.
//
//

#import "AttackEvent.h"
#import "Character.h"

@implementation AttackEvent
@synthesize attacker,type;

-(id)initWithAttacker:(Character *)aCharacter withAttackType:(AttackType)aType{
    if(self = [super init]) {
        attacker = aCharacter;
        type = aType;
        bonus = 0;
        multiplier = 1;
    }
    return self;
}


-(void)addToBonus:(float)aBonus {
    bonus += aBonus;
}

-(void)addToMultiplier:(float)aMultiplier {
    multiplier *= multiplier;
}

-(int)getDamage {
    return (attacker.attack + bonus) * multiplier;
}

@end
