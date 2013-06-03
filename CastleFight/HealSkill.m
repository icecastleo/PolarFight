//
//  HealSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "HealSkill.h"
#import "AttackEvent.h"
#import "AttackerComponent.h"

@implementation HealSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],kRangeKeySide,@[kRangeFilterSelf],kRangeKeyFilter,kRangeTypeCircle,kRangeKeyType,@75,kRangeKeyRadius,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 1.5;
    }
    return self;
}

-(void)activeEffect {
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    for (Entity *entity in [range getEffectEntities]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self.owner attackerComponent:attack damageType:kDamageTypeHeal damageSource:kDamageSourceMelee defender:entity];
        event.isCustomDamage = YES;
        event.isIgnoreDefense = YES;
        [self sideEffectWithEvent:event Entity:entity];
        [attack.attackEventQueue addObject:event];
    }
}

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    event.customDamage = -500;
}

@end
