//
//  MoveComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "MoveComponent.h"

@implementation MoveComponent

+(NSString *)name {
    static NSString *name = @"MoveComponent";
    return name;
}

-(id)initWithSpeedAttribute:(Attribute *)speed {
    if ((self = [super init])) {
        _speed = speed;
        _velocity = CGPointMake(0, 0);
    }
    return self;
}

@end
