//
//  DamageEvent.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/19.
//
//

#import <Foundation/Foundation.h>
#import "Damage.h"
#import "Entity.h"

@interface DamageEvent : NSObject {
    float bonus;
    float multiplier;
}

@property (readonly) Entity *sender;
@property (readonly) DamageType type;
@property (readonly) DamageSource source;
@property (readonly) Entity *receiver;
@property (readonly) int baseDamage;
@property CGPoint position;
@property float knockOutPower;
@property BOOL knouckOutCollision;
@property BOOL isCustomDamage;

@property BOOL isInvalid;

-(id)initWithSender:(Entity *)sender damage:(int)damage damageType:(DamageType)type damageSource:(DamageSource)source receiver:(Entity *)receiver;

-(void)addDamage:(float)aBonus;
-(void)subtractDamage:(float)aBonus;
-(void)addMultiplier:(float)aMultiplier;
-(void)subtractMultiplier:(float)aMultiplier;

-(Damage*)convertToDamage;

@end
