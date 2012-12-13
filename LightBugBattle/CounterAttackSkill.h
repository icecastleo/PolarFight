//
//  CounterAttackSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/11.
//
//

#import "PassiveSkill.h"

@interface CounterAttackSkill : PassiveSkill {
    Effect *counterAttackEffect;
}

-(id)initWithProbability:(int)probability;

@end
