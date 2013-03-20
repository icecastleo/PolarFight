//
//  SwordmanSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "SwordmanSkill.h"
#import "Character.h"
#import "CCMoveCharacterBy.h"

@implementation SwordmanSkill

-(void)setRanges {    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeFanShape,kRangeKeyType,@75,kRangeKeyRadius,@(M_PI/2),@"effectAngle",nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
    
    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@150,kRangeKeyRadius,nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary2]];
    [ranges addObject:ranges[0]];
    
}

-(void)activeSkill:(int)count {
    for (Character *target in [range getEffectTargets]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:target];
        event.knockOutPower = 25;
        event.knouckOutCollision = YES;
        [target receiveAttackEvent:event];
    }
}
@end
