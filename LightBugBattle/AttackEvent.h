//
//  Attack.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/4.
//
//

#import <Foundation/Foundation.h>
#import "Constant.h"
@class Character;

@interface AttackEvent : NSObject {
    float bonus;
    float multiplier;
}

@property (retain,readonly) Character *attacker;
@property (readonly) AttackType type;

-(id)initWithAttacker:(Character*)aCharacter withAttackType:(AttackType)aType;

-(int)getDamage;
-(void)addToBonus:(float)aBonus;
-(void)addToMultiplier:(float)aMultiplier;

@end
