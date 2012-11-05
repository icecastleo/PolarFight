//
//  DPadLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "DPadLayer.h"


@implementation DPadLayer

@synthesize velocity;

-(id)init {
    if(self = [super init]) {
        [self isTouchEnabled];
        
        SneakyJoystickSkinnedBase *leftJoy = [[SneakyJoystickSkinnedBase alloc] init];
        leftJoy.position = ccp(80,64);
        leftJoy.backgroundSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 128) radius:32];
        leftJoy.thumbSprite = [ColoredCircleSprite circleWithColor:ccc4(0, 0, 255, 200) radius:16];
        leftJoy.joystick = [[SneakyJoystick alloc] initWithRect:CGRectMake(0,0,64,64)];
        leftJoystick = leftJoy.joystick;
        [self addChild:leftJoy];
        
        SneakyButtonSkinnedBase *rightBut = [[SneakyButtonSkinnedBase alloc] init];
        rightBut.position = ccp(400,64);
        rightBut.defaultSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 128) radius:32];
        rightBut.activatedSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 255, 255, 255) radius:32];
        rightBut.pressSprite = [ColoredCircleSprite circleWithColor:ccc4(255, 0, 0, 255) radius:32];
        rightBut.button = [[SneakyButton alloc] initWithRect:CGRectMake(0, 0, 64, 64)];
        attackButton = rightBut.button;
        attackButton.isToggleable = NO;
        [self addChild:rightBut];
    }
    return self;
}

-(CGPoint) velocity {
    return leftJoystick.velocity;
}

-(Boolean) isButtonPressed {
    if(attackButton.active) {
        attackButton.active = NO;
        return YES;
    } else {
        return NO;
    }
}

@end
