//
//  SlowMoveAura.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "SlowMoveAura.h"
#import "SlowMoveSkill.h"

@implementation SlowMoveAura

-(id)initWithCharacter:(Character *)aCharacter {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@125,@"effectRadius",nil];
    
    if (self = [super initWithCharacter:aCharacter rangeDictionary:dictionary auraPassiveSkillClass:[SlowMoveSkill class]]) {
        
    }
    return self;
}

@end
