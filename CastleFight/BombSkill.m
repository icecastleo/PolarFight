//
//  BombSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/24.
//
//

#import "BombSkill.h"
#import "Character.h"

@implementation BombSkill

-(void)setRanges {
    
}

-(void)execute {
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"arrow.png",@"rangeSpriteFile",nil];
//    
//    RangeShooter *shooter = [[RangeShooter alloc] initWithRange:[Range rangeWithCharacter:character parameters:dictionary]];
//    
//    [shooter shoot:character.direction speed:10 delegate:self];
}

-(void)delayExecute:(NSArray *)targets effectPosition:(CGPoint)position {
//    for(Character *target in targets) {
//        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackRange defender:target];
//        event.position = position;
//        [target receiveAttackEvent:event];
//    }
}

@end
