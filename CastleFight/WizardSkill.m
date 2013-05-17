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
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@100,kRangeKeyRadius,@150,kRangeKeyDistance,nil];

    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
}

-(void)execute {
    for (Character *target in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character damageType:kDamageTypeFire damageSource:kDamageSourceRanged defender:target];
        [target receiveAttackEvent:event];
    }
}

@end
