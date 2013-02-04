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

@property (readonly) Character *attacker;
@property (readonly) Character *defender;
@property (readonly) AttackType type;
@property (readonly) int attack;
@property CGPoint position;
@property float knockOutPower;
@property BOOL knouckOutCollision;

-(id)initWithAttacker:(Character *)anAttacker attackType:(AttackType)aType defender:(Character*)aDefender;

-(void)addAttack:(float)aBonus;
-(void)subtractAttack:(float)aBonus;
-(void)addMultiplier:(float)aMultiplier;
-(void)subtractMultiplier:(float)aMultiplier;

-(DamageEvent*)convertToDamageEvent;

@end
