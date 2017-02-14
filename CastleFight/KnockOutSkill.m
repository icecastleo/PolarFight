//
//  KnockOutSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/28.
//
//

#import "KnockOutSkill.h"
#import "KnockOutComponent.h"
#import "DamageEvent.h"
#import "SideEffect.h"
#import "AttackEvent.h"
#import "RenderComponent.h"

@implementation KnockOutSkill

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
    KnockOutComponent *component = [[KnockOutComponent alloc] init];
    component.cdTime = 0; // once only
    component.totalTime = 0;
    component.animationDuration = 0.5; //show time
    
    component.attack = event.attack.attack.value;
    SideEffect *sideEffect = [[SideEffect alloc] initWithSideEffectCommponent:component andPercentage:100];
    [event.sideEffects addObject:sideEffect];
}

@end
