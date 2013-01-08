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
@property (readonly) Character *damager;
@property (readonly) int baseDamage;
//@property float bonus;
//@property float multiplier;

-(id)initWithBaseDamage:(int)aNumber damageType:(DamageType)aType damager:(Character*)aCharacter;

-(void)addDamage:(float)aBonus;
-(void)subtractDamage:(float)aBonus;
-(void)addMultiplier:(float)aMultiplier;
-(void)subtractMultiplier:(float)aMultiplier;

-(Damage*)convertToDamage;

@end
