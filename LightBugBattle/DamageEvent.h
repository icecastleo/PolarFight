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

}

@property (readonly) DamageType type;
@property (readonly) Character *damager;
//@property (readonly) int damage;
@property (readonly) int baseDamage;
@property float bonus;
@property float multiplier;

-(id)initWithBaseDamage:(int)aNumber damageType:(DamageType)aType damager:(Character*)aCharacter;

-(Damage*)convertToDamage;

@end
