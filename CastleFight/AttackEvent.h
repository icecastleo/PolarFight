//
//  Attack.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/4.
//
//

#import <Foundation/Foundation.h>
#import "DamageEvent.h"
#import "Entity.h"
#import "AttackerComponent.h"

@interface AttackEvent : NSObject {
    float bonus;
    float multiplier;
}

@property (readonly) Entity *attacker;
// Retain it for projectile event, because attacker might be dead before hit enemy!
@property (readonly) AttackerComponent *attack;
@property (readonly) Entity *defender;
@property (readonly) DamageType type;
@property (readonly) DamageSource source;
@property BOOL isIgnoreDefense;
@property BOOL isCustomDamage;
@property int customDamage;

@property CGPoint position;
@property float knockOutPower;
@property BOOL knouckOutCollision;
@property NSMutableArray *sideEffects;

@property BOOL isInvalid;

-(id)initWithAttacker:(Entity *)attacker attackerComponent:(AttackerComponent *)attack damageType:(DamageType)type damageSource:(DamageSource)source defender:(Entity *)defender;
-(DamageEvent*)convertToDamageEvent;

@end
