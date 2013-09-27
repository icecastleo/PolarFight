
//  MeleeAttackSkill.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "MeleeAttackSkill.h"
#import "AttackEvent.h"
#import "AttackerComponent.h"
#import "Attribute.h"
#import "ActiveSkillComponent.h"
#import "RenderComponent.h"

@implementation MeleeAttackSkill

-(id)init {
    if (self = [super init]) {
//        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@30,kRangeKeyRadius,@1,kRangeKeyTargetLimit,nil];
//        
//        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 1.5;
    }
    return self;
}

-(void)setOwner:(Entity *)owner {
    RenderComponent *render = (RenderComponent *)[owner getComponentOfName:[RenderComponent name]];
    int width = render.sprite.boundingBox.size.width;
    int height = render.sprite.boundingBox.size.height;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSquare,kRangeKeyType,[NSNumber numberWithInt:width],kRangeKeyWidth,[NSNumber numberWithInt:height],kRangeKeyHeight,@1,kRangeKeyTargetLimit,nil];
    
    range = [Range rangeWithParameters:dictionary];
    
    [super setOwner:owner];
    
    ActiveSkillComponent *component = (ActiveSkillComponent *)[owner getComponentOfName:[ActiveSkillComponent name]];
    
    Attribute *agile = component.agile;
    
    if (agile) {
        self.cooldown = self.cooldown / ((float)agile.value/15);
    }
}

-(void)activeEffect {
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfName:[AttackerComponent name]];
    
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:entity];
        
//        event.knockOutPower = 25;
//        event.knouckOutCollision = YES;
        [attack.attackEventQueue addObject:event];
    }
}

@end
