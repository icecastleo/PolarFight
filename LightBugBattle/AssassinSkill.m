//
//  AssassinSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/24.
//
//

#import "AssassinSkill.h"

@implementation AssassinSkill

-(void)characterWillAddDelegate:(Character *)sender {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly, kRangeSideEnemy],@"rangeSides",@[kRangeFilterSelf],@"rangeFilters",kRangeTypeCircle,@"rangeType",@150,@"effectRadius",nil];
    
    range = [Range rangeWithCharacter:sender parameters:dictionary];
}

-(void)character:(Character *)sender willSendAttackEvent:(AttackEvent *)event {
    int count = [range getEffectTargets].count;
    
    if (count < 3) {
        [event addAttack: (3 - count) * event.attack * 0.25];
    }
}

@end
