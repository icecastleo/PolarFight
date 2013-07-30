//
//  AIComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "AIComponent.h"
#import "AIState.h"

@interface AIComponent() {
    AIState *tempState;
}

@end

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

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventPrepare || type == kEntityEventDead) {
        [_state exit:self.entity];
        tempState = _state;
        _state = nil;
    } else if (type == kEntityEventReady || type == kEntityEventRevive) {
        _state = tempState;
        tempState = nil;
        [_state enter:self.entity];
    }
    
    if ([_state respondsToSelector:@selector(receiveEvent:Message:)]) {
        [_state receiveEvent:type Message:message];
    }
}

-(void)dealloc {
    [_state exit:self.entity];
}

@end