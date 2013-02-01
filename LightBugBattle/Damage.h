//
//  Damage.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/24.
//
//

#import <Foundation/Foundation.h>

@class Character;
@interface Damage : NSObject {
    
}

@property (readonly) DamageType type;
@property (readonly) Character *damager;
@property (readonly) int value;
@property CGPoint position;
@property float knockOutPower;
@property BOOL knouckOutCollision;

-(id)initWithValue:(int)aNumber damageType:(DamageType)aType damager:(Character*)aCharacter;

@end
