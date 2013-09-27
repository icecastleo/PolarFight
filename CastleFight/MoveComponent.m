//
//  MoveComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "MoveComponent.h"
#import "cocos2d.h"

@implementation MoveComponent

+(NSString *)name {
    static NSString *name = @"MoveComponent";
    return name;
}

-(id)initWithSpeedAttribute:(Attribute *)speed {
    if ((self = [super init])) {
        _speed = speed;
        _velocity = CGPointZero;
    }
    return self;
}

-(void)setVelocity:(CGPoint)velocity {
    if (CGPointEqualToPoint(velocity, CGPointZero)) {
        _velocity = velocity;
    } else {
        _velocity = ccpNormalize(velocity);
    }
}

@end
