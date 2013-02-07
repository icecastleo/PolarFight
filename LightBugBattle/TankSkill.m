//
//  TankSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/10.
//
//

#import "TankSkill.h"
#import "Character.h"
#import "BattleController.h"

@implementation TankSkill

-(void)setRanges {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@100,@"effectRadius",nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
}

-(void)execute {
    for (Character *target in [range getEffectTargets]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        event.knockOutPower = -20;
        [target receiveAttackEvent:event];
    }
}

@end
