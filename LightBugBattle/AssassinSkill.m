//
//  AssassinSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/24.
//
//

#import "AssassinSkill.h"

@implementation AssassinSkill

//-(id)init {
//    if (self = [super init]) {
//        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],@"rangeSides",@[kRangeFilterSelf],@"rangeFilters",kRangeTypeCircle,@"rangeType",@50,@"effectRadius",nil];
//        
//        range = [Range rangeWithParameters:dictionary onCharacter:aCharacter];
//    }
//    return self;
//}

-(void)character:(Character *)sender willSendAttackEvent:(AttackEvent *)event {
    if (range == nil) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly, kRangeSideEnemy],@"rangeSides",@[kRangeFilterSelf],@"rangeFilters",kRangeTypeCircle,@"rangeType",@300,@"effectRadius",nil];
        
        range = [Range rangeWithParameters:dictionary onCharacter:sender];
    }
    
    int count = [range getEffectTargets].count;
    
    if (count < 3) {
        [event addAttack: (3 - count) * event.attack * 0.25];
    }
}

@end
