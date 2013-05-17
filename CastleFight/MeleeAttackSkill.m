
//  MeleeAttackSkill.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "MeleeAttackSkill.h"
#import "AttackEvent.h"
#import "AttackerComponent.h"

@implementation MeleeAttackSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeFanShape,kRangeKeyType,@40,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 2;
    }
    return self;
}

-(void)activeEffect {
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:entity];
//        event.knockOutPower = 25;
//        event.knouckOutCollision = YES;
        
        AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
        [attack.attackEventQueue addObject:event];
    }
}

@end
