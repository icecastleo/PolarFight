//
//  BattleLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleLayer.h"


@implementation BattleLayer

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BattleLayer *layer = [BattleLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	if(self = [super init]) {
		self.isTouchEnabled = YES;
				
        [self initJoystick];
        
        currentSprite = [CCSprite spriteWithFile:@"amg1_rt1.gif"];
        
        currentSprite.position = ccp( 100, 100);
        
        [self addChild: currentSprite];
        
        [self scheduleUpdate];
	}
	return self;
}

-(void) initJoystick {
    
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

- (void) update:(ccTime) delta {
    CCLOG(@"%f",delta);
    currentSprite.position = ccpAdd(currentSprite.position, ccpMult(leftJoystick.velocity, 150.0 * delta ));
}

-(void)dealloc {
    
    [leftJoystick release];
    [attackButton release];
    [super dealloc];
}
@end
