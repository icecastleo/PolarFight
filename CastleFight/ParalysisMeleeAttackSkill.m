//
//  ParalysisMeleeAttackSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/24.
//
//

#import "ParalysisMeleeAttackSkill.h"
#import "SideEffect.h"
#import "ParalysisComponent.h"
#import "AttackEvent.h"
#import "DamageEvent.h"
#import "RenderComponent.h"

@implementation ParalysisMeleeAttackSkill

-(void)setOwner:(Entity *)owner {
    RenderComponent *render = (RenderComponent *)[owner getComponentOfName:[RenderComponent name]];
    int width = render.sprite.boundingBox.size.width;
    int height = render.sprite.boundingBox.size.height;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:width],kRangeKeyWidth,[NSNumber numberWithInt:height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,nil];
    
    range = [Range rangeWithParameters:dictionary];
    
    [super setOwner:owner];
    
    self.cooldown = 1.5;
}

-(void)activeEffect {
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfName:[AttackerComponent name]];
    
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:entity];
        //        event.knockOutPower = 25;
        //        event.knouckOutCollision = YES;
        [self sideEffectWithEvent:event Entity:entity];
        [attack.attackEventQueue addObject:event];
    }
}

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    ParalysisComponent *component = [[ParalysisComponent alloc] init];
    component.cdTime = 3;
    component.totalTime = 3;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:100];
    [event.sideEffects addObject:sideEffect];
}

@end
