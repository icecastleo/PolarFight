//
//  Aura.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "AttackUpAura.h"
#import "AttackerComponent.h"
#import "AttackBonusMultiplierComponent.h"

@implementation AttackUpAura

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@80,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@10,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 1;
    }
    return self;
}

-(void)activeEffect {
    
    for (Entity *entity in [range getEffectEntities]) {
        AttackBonusMultiplierComponent *component = (AttackBonusMultiplierComponent *)[entity getComponentOfClass:[AttackBonusMultiplierComponent class]];
        if (component) {
            continue;
        }
        AttackerComponent *receiver = (AttackerComponent *)[entity getComponentOfClass:[AttackerComponent class]];
        component = [[AttackBonusMultiplierComponent alloc] initWithAttribute:receiver.attack andBonus:10];
        component.cdTime = 0;
        component.totalTime = 1;
        [entity addComponent:component];
    }
}

@end
