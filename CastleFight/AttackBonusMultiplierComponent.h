//
//  AttackBonusMultiplierComponent.h
//  CastleFight
//
//  Created by  DAN on 13/6/7.
//
//

#import "StateComponent.h"

@class Attribute;

@interface AttackBonusMultiplierComponent : StateComponent

@property (nonatomic,readonly) BOOL isExecuting;
@property (nonatomic,readonly) Attribute *attribute;
@property (nonatomic,readonly) float bonus;

-(id)initWithAttribute:(Attribute *)attribute andBonus:(float)bonus;

@end
