//
//  AttackEffect.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/5.
//
//

#import "Effect.h"

@interface AttackEffect : Effect {
    AttackType type;
}

-(id)initWithAttackType:(AttackType)aType;

@end
