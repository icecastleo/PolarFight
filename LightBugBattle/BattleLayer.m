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
        
        sprites = [[NSMutableArray alloc] init];
        
//        currentSprite = [CCSprite spriteWithFile:@"amg1_rt1.gif"];
//        
//        currentSprite.position = ccp( 100, 100);
//        
//        [self addChild: currentSprite];
        
        int number = 2;
        
        for (int i = 0; i < number; i++) {
//            BattleSprite *sprite = [BattleSprite spriteWithRandomAbility];
            
            BattleSprite *sprite = [BattleSprite spriteWithFile:@"amg1" player:1];
            
//            sprite.position = ccp(arc4random() % 400 + 40, arc4random() % 280 + 20);
            
            [self addSprite:sprite];
        }
        
        for (int i = 0; i < number; i++) {
            BattleSprite *sprite = [BattleSprite spriteWithFile:@"avt1" player:2];
            
            [self addSprite:sprite];
        }

        
        canMove = YES;
        isMove = NO;
        cumulativeTime = 0;
        
        currentIndex = 0;
        currentSprite = sprites[currentIndex];
        
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

-(void)dealloc {
    
    [leftJoystick release];
    [attackButton release];
    [sprites release];
    [super dealloc];
}

- (void) addSprite:(CCSprite*) sprite {
    [sprites addObject:sprite];
    [self addChild:sprite];
}

- (void) update:(ccTime) delta {
    
    if(!canMove)
        return;
    
    if(!isMove && (leftJoystick.velocity.x != 0 || leftJoystick.velocity.y != 0))
        isMove = YES;
    
    if(isMove) {
        
        cumulativeTime += delta;
        
        if(cumulativeTime > currentSprite.moveTime) {
            [currentSprite end];
            [self endMove];
            return;
        }
        
        if(currentSprite.state == stateAttack && currentSprite.numberOfRunningActions != 0) {
            return;
        }
        
        if(attackButton.active) {
            [currentSprite attackEnemy:nil];
            return;
        }
        
        [currentSprite addPosition:leftJoystick.velocity time:delta];       
    }
}

-(void) endMove {
    canMove = NO;
    
    // 回合結束的檢查
    
    isMove = NO;
    cumulativeTime = 0;
    
    currentIndex = ++currentIndex % sprites.count;
    
    currentSprite = sprites[currentIndex];
    
    canMove = YES;
}

@end
