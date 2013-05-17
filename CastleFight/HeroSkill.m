//
//  HeroSkill.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/21.
//
//

#import "HeroSkill.h"
#import "Character.h"

@implementation HeroSkill

-(void)setRanges {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeFanShape,kRangeKeyType,@100,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];

    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeFanShape,kRangeKeyType,@100,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,nil];

    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary2]];
}

-(void)activeSkill:(int)count {
    for (Character *target in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:target];
        event.knockOutPower = 25;
        event.knouckOutCollision = YES;
        [target receiveAttackEvent:event];
    }
}

@end
