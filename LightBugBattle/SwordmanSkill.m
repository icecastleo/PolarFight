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
    //        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"tree01.gif",@"rangeSpriteFile",@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@50,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@75,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
    
    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@150,@"effectRadius",nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary2]];
    [ranges addObject:ranges[0]];
    
    [character.sprite setSkillAnimationWithName:character.name andCombosCount:ranges.count];
}

-(void)activeSkill:(int)count {
    for (Character *target in [range getEffectTargets]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        event.knockOutPower = 25;
        event.knouckOutCollision = YES;
        [target receiveAttackEvent:event];
    }
}
@end
