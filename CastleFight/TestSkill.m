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
    // TODO: Maybe show the arrow range.
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@200,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
    
    [ranges addObject:[Range rangeWithCharacter:character parameters:dictionary]];
}

-(void)activeSkill:(int)count {
    //    NSMutableDictionary *effectDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@50,@"effectRadius",nil];
    
    //    Range *effectRange = [Range rangeWithCharacter:character parameters:effectDictionary];
    
    //    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"Arrow.png",@"rangeSpriteFile",effectRange,@"rangeEffectRange",nil];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"Arrow.png",@"rangeSpriteFile",nil];
    
    DelegateSkill *delegate = [[AttackDelegateSkill alloc] initWithCharacter:character];
    
//    RangeShooter *shooter = [[RangeShooter alloc] initWithRange:[Range rangeWithCharacter:character parameters:dictionary] delegateSkill:delegate];

//    [shooter shootFrom:character.position toPosition:ccpAdd(character.position, (character.player == 1)? ccp(200,0):ccp(-200,0)) speed:10];

    RangeShooterNew *shooter = [[RangeShooterNew alloc] initWithRange:[Range rangeWithCharacter:character parameters:dictionary] delegateSkill:delegate];
    
    // TODO: 可指定攻擊地點
    CGPoint target = (character.player == 1)?ccp(200,0):ccp(-200,0);
    [shooter shoot:ccpAdd(character.position, target) time:2];
}

@end
