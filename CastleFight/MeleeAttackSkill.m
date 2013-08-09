
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

@implementation MeleeAttackSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@30,kRangeKeyRadius,@1,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 1.5;
    }
    return self;
}

-(void)setOwner:(Entity *)owner {
    [super setOwner:owner];
    
    ActiveSkillComponent *component = (ActiveSkillComponent *)[owner getComponentOfClass:[ActiveSkillComponent class]];
    
    Attribute *agile = component.agile;
    
    if (agile) {
        self.cooldown = self.cooldown / ((float)agile.value/15);
    }
}

-(void)activeEffect {
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeNormal damageSource:kDamageSourceMelee defender:entity];
        
//        event.knockOutPower = 25;
//        event.knouckOutCollision = YES;
        [attack.attackEventQueue addObject:event];
    }
}

@end
