
//  MeleeAttackSkill.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "MeleeAttackSkill.h"
#import "AttackEvent.h"
#import "AttackerComponent.h"

#import "SideEffect.h"
#import "PoisonComponent.h"

@implementation MeleeAttackSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeFanShape,kRangeKeyType,@40,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 1.5;
    }
    return self;
}

-(void)activeEffect {
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:entity];
//        event.knockOutPower = 25;
//        event.knouckOutCollision = YES;
        [self sideEffectWithEvent:event Entity:entity];
        
//        PoisonComponent *poison = [[PoisonComponent alloc] init];
//        poison.cdTime = 1;
//        poison.totalTime = 100000;
//        DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:50 damageType:kDamageTypePoison damageSource:kDamageSourceMelee receiver:entity];
//        poison.event = damageEvent;
//        SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:poison andPercentage:0.5];
//        [event.sideEffects addObject:sideEffect];
        
//        AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
        [attack.attackEventQueue addObject:event];
    }
}

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    
}

@end
