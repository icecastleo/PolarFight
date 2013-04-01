//
//  DPadLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DPadLayer.h"

@implementation DPadLayer

@dynamic velocity;

static const int backgroundRadius = 50;
static const int thumbSpriteRadius = 25;
static const int ButtonDistance = 100;

-(id)init {
    if(self = [super init]) {
        [self isTouchEnabled];
        
        SneakyJoystickSkinnedBase *leftJoy = [[SneakyJoystickSkinnedBase alloc] init];
        leftJoy.position = ccp(ButtonDistance,64);
        leftJoy.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 64) radius:backgroundRadius];
        leftJoy.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 100) radius:thumbSpriteRadius];
        leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,64,64)];
        leftJoystick = leftJoy.joystick;
        [self addChild:leftJoy];
        
        SneakyButtonSkinnedBase *rightBut = [[SneakyButtonSkinnedBase alloc] init];
        rightBut.position = ccp([CCDirector sharedDirector].winSize.width - ButtonDistance,64);
        rightBut.defaultSprite = [ColoredCircleSprite circleWithColor:ccc4(50, 50, 50, 100) radius:backgroundRadius];
        rightBut.activatedSprite = [ColoredCircleSprite circleWithColor:ccc4(50, 50, 50, 100) radius:backgroundRadius];
        rightBut.pressSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 100) radius:backgroundRadius];
        rightBut.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
        attackButton = rightBut.button;
        attackButton.isToggleable = NO;
        [self addChild:rightBut];
    }
    return self;
}

-(CGPoint)velocity {
    if (leftJoystick.velocity.x == 0 && leftJoystick.velocity.y == 0) {
        return leftJoystick.velocity;
    } else {
//        return leftJoystick.velocity;
        
        // Ignore the distance of thoumb and dpad's center point.
        return ccpNormalize(leftJoystick.velocity);
    }
}

-(Boolean)isButtonPressed {
    if(attackButton.active) {
        attackButton.active = NO;
        return YES;
    } else {
        return NO;
    }
}

@end
