//
//  Component.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"

@implementation Component

-(void)sendEvent:(EventType)type Message:(id)message {
    [_entity sendEvent:type Message:message];
}

-(void)receiveEvent:(EventType)type Message:(id)message {

}

@end
