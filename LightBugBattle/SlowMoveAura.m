//
//  SlowMoveAura.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "SlowMoveAura.h"
#import "SlowMovePassiveSkill.h"
#import "Character.h"

@implementation SlowMoveAura

-(NSMutableDictionary *)getRangeDictionary {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@125,@"effectRadius",nil];
}

-(void)execute:(Character *)target {
    SlowMovePassiveSkill *skill = [[SlowMovePassiveSkill alloc] init];
    skill.duration = kPassiveSkillDuration;
    [target addPassiveSkill:skill];
}

@end
