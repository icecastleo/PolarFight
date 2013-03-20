//
//  AttackEffect.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/5.
//
//

#import "Effect.h"

@interface AttackEffect : Effect {
    DamageType type;
}

-(id)initWithAttackType:(DamageType)aType;

@end
