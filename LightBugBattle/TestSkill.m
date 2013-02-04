//
//  TestSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/14.
//
//

#import "TestSkill.h"
#import "AttackEvent.h"
#import "Character.h"
#import "RangeCarrier.h"
#import "RangeShooter.h"

@implementation TestSkill

-(void)execute {
    
//    NSMutableDictionary *effectDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@50,@"effectRadius",nil];
    
//    Range *effectRange = [Range rangeWithCharacter:character parameters:effectDictionary];
    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"Arrow.png",@"rangeSpriteFile",effectRange,@"rangeEffectRange",nil];
    
     NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"Arrow.png",@"rangeSpriteFile",nil];
    
    RangeShooter *shooter = [[RangeShooter alloc] initWithRange:[Range rangeWithCharacter:character parameters:dictionary]];
    
    [shooter shoot:character.direction speed:10 delegate:self];
}

-(void)delayExecute:(NSArray *)targets effectPosition:(CGPoint)position {
    for(Character *target in targets) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        event.position = position;
        [target receiveAttackEvent:event];
    }
}

@end
