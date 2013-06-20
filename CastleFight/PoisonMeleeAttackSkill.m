//
//  PoisonMeleeAttackSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/24.
//
//

#import "PoisonMeleeAttackSkill.h"
#import "SideEffect.h"
#import "PoisonComponent.h"
#import "AttackEvent.h"
#import "DamageEvent.h"

@implementation PoisonMeleeAttackSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@80,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];
        
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
        [attack.attackEventQueue addObject:event];
    }
}

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    PoisonComponent *component = [[PoisonComponent alloc] init];
    component.cdTime = 1;
    component.totalTime = 100;
    DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:ceilf(event.attack.attack.value/10.0) damageType:kDamageTypePoison damageSource:kDamageSourceMelee receiver:entity];
    component.event = damageEvent;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:50];
    [event.sideEffects addObject:sideEffect];
}

@end
