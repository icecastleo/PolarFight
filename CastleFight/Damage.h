//
//  Damage.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/24.
//
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@interface Damage : NSObject {
    
}

@property (readonly) Entity *sender;
@property (readonly) int damage;
@property (readonly) DamageType type;
@property (readonly) DamageSource source;

@property CGPoint position;
@property float knockOutPower;
@property BOOL knouckOutCollision;

-(id)initWithSender:(Entity *)sender damage:(int)damage damageType:(DamageType)type damageSource:(DamageSource)source;

@end
