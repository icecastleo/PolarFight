//
//  HealSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "ActiveSkill.h"

@class AttackEvent;

@interface HealSkill : ActiveSkill

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity;

@end
