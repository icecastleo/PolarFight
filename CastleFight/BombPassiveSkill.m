//
//  BombPassiveSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/11.
//
//

#import "BombPassiveSkill.h"
#import "BombComponent.h"
#import "DamageEvent.h"
#import "SideEffect.h"
#import "AttackEvent.h"

@interface BombPassiveSkill()
@property (nonatomic,readonly) BOOL isActivated;
@end

@implementation BombPassiveSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@75,kRangeKeyRadius,nil];
        
        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)checkEvent:(EventType)eventType {
    switch (eventType) {
        case KEventDead:
            _isActivated = YES;
            break;
            
        default:
            break;
    }
}

-(void)activeEffect {
    
    if (!self.isActivated) {
        return;
    }
    
    AttackerComponent *attack = (AttackerComponent *)[self.owner getComponentOfClass:[AttackerComponent class]];
    
    for (Entity *entity in [range getEffectEntities]) {
        BombComponent *component = [[BombComponent alloc] init];
        component.cdTime = 0; // only once
        component.totalTime = 0;
        DamageEvent *damageEvent = [[DamageEvent alloc] initWithSender:self.owner damage:300*attack.attack.value damageType:kDamageTypeBomb damageSource:kDamageSourceMelee receiver:entity];
        component.event = damageEvent;
        
        [entity addComponent:component];
    }
}

@end
