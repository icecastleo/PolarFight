//
//  ArmyBearAttackSkill.m
//  CastleFight
//
//  Created by 朱 世光 on 13/6/25.
//
//

#import "ArmyBearAttackSkill.h"
#import "AttackEvent.h"
#import "AttackerComponent.h"

@implementation ArmyBearAttackSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@80,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 3;
    }
    return self;
}

-(void)activeEffect {
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
        //        event.knockOutPower = 25;
        //        event.knouckOutCollision = YES;
        [attack.attackEventQueue addObject:event];
    }
}

@end
