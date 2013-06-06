//
//  SideEffect.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/23.
//
//

#import "SideEffect.h"
#import "StateComponent.h"

@implementation SideEffect

-(id)initWithSideEffectCommponent:(StateComponent *)component andPercentage:(int)percentage {
    if (self = [super init]) {
        _components = [NSMutableArray new];
        [_components addObject:component];
        _percentage = percentage;
    }
    return self;
}

@end
