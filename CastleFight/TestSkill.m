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
#import "RangeShooter.h"
#import "RangeShooterNew.h"
#import "BattleController.h"
#import "AttackDelegateSkill.h"

@implementation TestSkill

-(void)setRanges {

    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeFanShape,kRangeKeyType,@150,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
}

-(void)activeSkill:(int)count {
    //    NSMutableDictionary *effectDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@50,@"effectRadius",nil];
    
    //    Range *effectRange = [Range rangeWithCharacter:character parameters:effectDictionary];
    
    //    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"arrow.png",@"rangeSpriteFile",effectRange,@"rangeEffectRange",nil];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSprite,kRangeKeyType,@"arrow.png",kRangeKeySpriteFile,nil];
    
    DelegateSkill *delegate = [[AttackDelegateSkill alloc] initWithCharacter:character];

    RangeShooterNew *shooter = [[RangeShooterNew alloc] initWithRange:[Range rangeWithCharacter:character parameters:dictionary] delegateSkill:delegate];
    
    // TODO: 可指定攻擊地點
    NSArray *effectTargets = [range getEffectTargets];
    
    if(effectTargets.count > 0){
        Character *target = effectTargets[0];
        [shooter shoot:target.position time:0.75];
    }
}

@end
