//
//  SideEffect.m
//  CastleFight
//
//  Created by  DAN on 13/5/23.
//
//

#import "SideEffect.h"
#import "StateComponent.h"

@implementation SideEffect

-(id)initWithSideEffectCommponent:(StateComponent *)component andPercentage:(int)percentage {
    if (self = [super init]) {
        _component = component;
        _percentage = percentage;
    }
    return self;
}

@end
