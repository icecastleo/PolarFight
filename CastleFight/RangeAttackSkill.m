//
//  TestSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/14.
//
//

#import "RangeAttackSkill.h"
#import "AttackEvent.h"
#import "Character.h"
#import "RangeShooter.h"
#import "RangeShooterNew.h"
#import "BattleController.h"
#import "AttackDelegateSkill.h"

@implementation RangeAttackSkill
 
-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeFanShape,kRangeKeyType,@150,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)activeEffect {
    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSprite,kRangeKeyType,@"arrow.png",kRangeKeySpriteFile,nil];
//    
//    DelegateSkill *delegate = [[AttackDelegateSkill alloc] initWithCharacter:character];
//    
//    Range *arrowRange = [Range rangeWithParameters:dictionary];
//    arrowRange.owner = self.owner;
//    
//    RangeShooterNew *shooter = [[RangeShooterNew alloc] initWithRange:arrowRange delegateSkill:delegate];
//    
//    // TODO: 可指定攻擊地點
//    
//    NSArray *effectEntities = [range getEffectEntities];
//    
//    if(effectEntities.count > 0){
//        Character *target = effectTargets[0];
//        [shooter shoot:target.position time:0.75];
//    }

    
//    for (Entity *entity in [range getEffectEntities]) {
//        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:entity];
//        //        event.knockOutPower = 25;
//        //        event.knouckOutCollision = YES;
//        
//        AttackerComponent *attack = (AttackerComponent *)[entity getComponentOfClass:[AttackerComponent class]];
//        [attack.attackEventQueue addObject:event];
//    }
}

//-(void)activeSkill:(int)count {
    //    NSMutableDictionary *effectDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@50,@"effectRadius",nil];
    
    //    Range *effectRange = [Range rangeWithCharacter:character parameters:effectDictionary];
    
    //    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"arrow.png",@"rangeSpriteFile",effectRange,@"rangeEffectRange",nil];
    
//    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSprite,kRangeKeyType,@"arrow.png",kRangeKeySpriteFile,nil];
//    
//    DelegateSkill *delegate = [[AttackDelegateSkill alloc] initWithCharacter:character];
//
//    RangeShooterNew *shooter = [[RangeShooterNew alloc] initWithRange:[Range rangeWithCharacter:character parameters:dictionary] delegateSkill:delegate];
//    
//    // TODO: 可指定攻擊地點
//    NSArray *effectTargets = [range getEffectTargets];
//    
//    if(effectTargets.count > 0){
//        Character *target = effectTargets[0];
//        [shooter shoot:target.position time:0.75];
//    }
//}

@end
