//
//  WizardSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "WizardSkill.h"
#import "Character.h"

@implementation WizardSkill

-(void)setRanges {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeFarCircle,@"rangeType",@50,@"effectRadius",@100,@"effectDistance",nil];

    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
}

-(void)execute {
    for (Character *target in [range getEffectTargets]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        [target receiveAttackEvent:event];
    }
}

@end
