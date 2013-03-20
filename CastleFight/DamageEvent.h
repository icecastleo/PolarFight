//
//  DamageEvent.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/19.
//
//

#import <Foundation/Foundation.h>
#import "Damage.h"
@class Character;

@interface DamageEvent : NSObject {
    float bonus;
    float multiplier;
}

@property (readonly) DamageType type;
@property (readonly) DamageSource source;
@property (readonly) Character *damager;
@property (readonly) int baseDamage;
@property CGPoint position;
@property float knockOutPower;
@property BOOL knouckOutCollision;

-(id)initWithBaseDamage:(int)aNumber damageType:(DamageType)aType damageSource:(DamageSource)aSource damager:(Character*)aCharacter;

-(void)addDamage:(float)aBonus;
-(void)subtractDamage:(float)aBonus;
-(void)addMultiplier:(float)aMultiplier;
-(void)subtractMultiplier:(float)aMultiplier;

-(Damage*)convertToDamage;

@end
