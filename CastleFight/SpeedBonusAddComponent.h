//
//  SpeedBonusAddComponent.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/7.
//
//

#import "StateComponent.h"

@class Attribute;

@interface SpeedBonusAddComponent : StateComponent

@property (nonatomic,readonly) BOOL isExecuting;
@property (nonatomic,readonly) Attribute *attribute;
@property (nonatomic,readonly) float bonus;

-(id)initWithAttribute:(Attribute *)attribute andBonus:(float)bonus;

@end
