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
#import "RangeShooterNew.h"
#import "BattleController.h"
@implementation TestSkill

-(void)setRanges {
    // TODO: Maybe show the arrow range.
}

-(void)activeSkill:(int)count {
    //    NSMutableDictionary *effectDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@50,@"effectRadius",nil];
    
    //    Range *effectRange = [Range rangeWithCharacter:character parameters:effectDictionary];
    
    //    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"Arrow.png",@"rangeSpriteFile",effectRange,@"rangeEffectRange",nil];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"Arrow.png",@"rangeSpriteFile",nil];
    
//    RangeShooter *shooter = [[RangeShooter alloc] initWithRange:[Range rangeWithCharacter:character parameters:dictionary]];
//    
//    [shooter shoot:character.direction speed:10 delegate:self];
//    
//    
    RangeShooterNew *shooter = [[RangeShooterNew alloc] initWithRange:[Range rangeWithCharacter:character parameters:dictionary]];
    
    
    ///To DO: 可指定攻擊地點
    CGPoint target = (character.player==1)?ccp(300,0):ccp(-300,0);
    [shooter shoot:ccpAdd(character.position, target) time:2 delegate:self];
}

-(void)delayExecute:(NSArray *)targets effectPosition:(CGPoint)position {
    for(Character *target in targets) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        event.position = position;
        [target receiveAttackEvent:event];
    }
}
-(NSArray *)checkTarget{
    NSMutableSet *effectTargets = [NSMutableSet set];
    
    for(Character* temp in [BattleController currentInstance].characters)
    {
        if(character.player!=temp.player)
        {
            CGFloat distance= ccpDistance(character.position, temp.position);
           if( distance>290&&distance<310)
             [effectTargets addObject:temp];
        }
    }
    return [effectTargets allObjects];
}
@end
