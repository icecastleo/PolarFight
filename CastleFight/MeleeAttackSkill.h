//
//  MeleeAttackSkill.h
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "ActiveSkill.h"

@class AttackEvent;

@interface MeleeAttackSkill : ActiveSkill

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity;

@end
