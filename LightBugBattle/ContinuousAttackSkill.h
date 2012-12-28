//
//  ContinuousAttackSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/27.
//
//

#import "PassiveSkill.h"

@interface ContinuousAttackSkill : PassiveSkill {
    int percent;
    __weak Character *previousTarget;
    int time;
}

-(id)initWithBonusPercent:(int)percent;

@end
