//
//  BombPassiveSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/11.
//
//

#import "BombPassiveSkill.h"
#import "DefenderComponent.h"
#import "DamageEvent.h"
#import "SideEffect.h"
#import "AttackEvent.h"

@implementation BombPassiveSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@150,kRangeKeyRadius,nil];
        
        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)checkEvent:(EntityEvent)eventType  Message:(id)message {
    if (eventType != kEntityEventDead) {
        return;
    }
    [self activeEffect];
}

-(void)activeEffect {
    
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    for (Entity *entity in [range getEffectEntities]) {
        DefenderComponent *defense = (DefenderComponent *)[entity getComponentOfClass:[DefenderComponent class]];
        DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:300*attack.attack.value damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:entity];
        
        [defense.damageEventQueue addObject:damageEvent];
    }
}

@end
