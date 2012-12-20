//
//  ReflecAttackDamage.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/19.
//
//

#import "PassiveSkill.h"

@interface ReflectAttackDamage : PassiveSkill {
    
}

-(id)initWithProbability:(int)probability damagePercent:(int)percent;

@end
