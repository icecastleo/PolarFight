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

//-(id)initWithCharacter:(Character *)aCharacter {
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@125,@"effectRadius",nil];
//    
//    if (self = [super initWithCharacter:aCharacter rangeDictionary:dictionary]) {
//        
//    }
//    return self;
//}

-(void)execute {
//    CCLOG(@"%@",character.name);
    
    for (Character *target in [range getEffectTargets]) {
        SlowMovePassiveSkill *skill = [[SlowMovePassiveSkill alloc] init];
        skill.duration = kPassiveSkillDuration;
        [target addPassiveSkill:skill];
    }
}

@end
