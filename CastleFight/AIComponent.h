//
//  AIComponent.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"

@class AIState;

@interface AIComponent : Component

@property AIState *state;

@property (nonatomic) NSDictionary *skillProbability;
@property (readonly) NSArray *sortSkillProbabilities;
@property (nonatomic, readonly) int sumOfProbability;

-(id)initWithState:(AIState *)state;
-(id)initWithNSDictionary:(NSDictionary *)dic;

-(NSString *)getSkillNameFromNumber:(int)number;

@end
