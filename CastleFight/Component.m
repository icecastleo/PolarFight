//
//  Component.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"

@implementation Component

+(NSString *)name {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];

    static NSString *name = @"Component";
    return name;
}

-(void)sendEvent:(EntityEvent)type Message:(id)message {
    [_entity sendEvent:type Message:message];
}

@end
