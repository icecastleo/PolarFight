//
//  SpeedUpSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/7.
//
//

#import "SpeedUpSkill.h"
#import "SpeedBonusAddComponent.h"
#import "MoveComponent.h"

@interface SpeedUpSkill()
@end

@implementation SpeedUpSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@150,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@10,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 30;
    }
    return self;
}

-(void)activeEffect {
    
    for (Entity *entity in [range getEffectEntities]) {
        SpeedBonusAddComponent *component = (SpeedBonusAddComponent *)[entity getComponentOfName:[SpeedBonusAddComponent name]];
        if (component) {
            continue;
        }
        MoveComponent *receiver = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
        component = [[SpeedBonusAddComponent alloc] initWithAttribute:receiver.speed andBonus:30];
        component.cdTime = 0;
        component.totalTime = 15;
        [entity addComponent:component];
    }
}

@end
