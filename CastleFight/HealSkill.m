//
//  HealSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "HealSkill.h"
#import "Character.h"

@implementation HealSkill

-(void)setRanges {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],kRangeKeySide,@[kRangeFilterSelf],kRangeKeyFilter,kRangeTypeCircle,kRangeKeyType,@75,kRangeKeyRadius,nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
}

-(void)execute {
    int attack = [character getAttribute:kCharacterAttributeAttack].value;
    
    DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:attack / 3 damageType:kDamageTypeNormal damageSource:kDamageSourcePassiveSkill damager:character];
    [character receiveDamageEvent:event];
    
    for (Character *target in [range getEffectEntities]) {
        [target getHeal:attack];
    }
}

@end
