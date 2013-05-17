//
//  AIComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "AIComponent.h"
#import "AIState.h"

@implementation AIComponent

-(id)initWithState:(AIState *)state {
    if ((self = [super init])) {
        self.state = state;
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    [_state enter:entity];
}

-(void)dealloc {
    [_state exit:self.entity];
}

@end