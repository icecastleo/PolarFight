//
//  SpeedUpSkill.m
//  CastleFight
//
//  Created by  DAN on 13/6/7.
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
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@150,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@10,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 30;
    }
    return self;
}

-(void)activeEffect {
    
    for (Entity *entity in [range getEffectEntities]) {
        SpeedBonusAddComponent *component = (SpeedBonusAddComponent *)[entity getComponentOfClass:[SpeedBonusAddComponent class]];
        if (component) {
            continue;
        }
        MoveComponent *receiver = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
        component = [[SpeedBonusAddComponent alloc] initWithAttribute:receiver.speed andBonus:30];
        component.cdTime = 0;
        component.totalTime = 15;
        [entity addComponent:component];
    }
}

@end
