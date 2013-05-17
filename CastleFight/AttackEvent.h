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

@interface AttackEvent : NSObject {
    float bonus;
    float multiplier;
}

@property (readonly) Entity *attacker;
@property (readonly) Entity *defender;
@property (readonly) DamageType type;
@property (readonly) DamageSource source;
@property (readonly) int attack;
@property CGPoint position;
@property float knockOutPower;
@property BOOL knouckOutCollision;

@property BOOL isInvalid;

-(id)initWithAttacker:(Entity *)attacker damageType:(DamageType)type damageSource:(DamageSource)source defender:(Entity *)defender;
-(DamageEvent*)convertToDamageEvent;

@end
