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
#import "RenderComponent.h"

@implementation ArmyBearAttackSkill

-(void)setOwner:(Entity *)owner {
    RenderComponent *render = (RenderComponent *)[owner getComponentOfName:[RenderComponent name]];
    int width = render.sprite.boundingBox.size.width*4;
    int height = render.sprite.boundingBox.size.height;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:width],kRangeKeyWidth,[NSNumber numberWithInt:height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,nil];
    
    range = [Range rangeWithParameters:dictionary];
    
    [super setOwner:owner];
    
    self.cooldown = 3;
}

-(void)activeEffect {
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfName:[AttackerComponent name]];
    
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceRanged defender:entity];
        //        event.knockOutPower = 25;
        //        event.knouckOutCollision = YES;
        [attack.attackEventQueue addObject:event];
    }
}

@end
