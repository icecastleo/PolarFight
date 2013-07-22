//
//  NoiseSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/6.
//
//

#import "NoiseSkill.h"
#import "AttackEvent.h"
#import "ProjectileComponent.h"
#import "RenderComponent.h"
#import "DirectionComponent.h"
#import "AttackerComponent.h"

@implementation NoiseSkill

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeSimpleXY,kRangeKeyType,@150,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@5,kRangeKeyTargetLimit,nil];
        
        range = [Range rangeWithParameters:dictionary];
        self.cooldown = 2;
    }
    return self;
}


-(void)activeEffect {
    //TODO: Noise RangeAttack. 

}

@end
