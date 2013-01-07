//
//  Attack.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/4.
//
//

#import <Foundation/Foundation.h>
#import "DamageEvent.h"
@class Character;

@interface AttackEvent : NSObject {
    float bonus;
    float multiplier;
}

@property (retain,readonly) Character *attacker;
@property (retain,readonly) Character *defender;
@property (readonly) AttackType type;
@property (readonly) int attack;

-(id)initWithAttacker:(Character *)anAttacker attackType:(AttackType)aType defender:(Character*)aDefender;

-(void)addAttack:(float)aBonus;
-(void)subtractAttack:(float)aBonus;
-(void)addMultiplier:(float)aMultiplier;
-(void)subtractMultiplier:(float)aMultiplier;

-(DamageEvent*)convertToDamageEvent;

@end
