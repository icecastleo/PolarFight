//
//  DamageEffect.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/11.
//
//

#import "Effect.h"

@interface DamageEffect : Effect {
    int damage;
}

-(id)initWithDamage:(int)damage;

@end
