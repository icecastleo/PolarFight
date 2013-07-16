//
//  HelloWorldLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "BattleController.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"
#import "StageLayer.h"
#import "MainScene.h"
#import "FileManager.h"
#import "ExampleLayer.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"mainbutton.plist"];
        
        // GameCenter 
        GameCenterManager *gkHelper = [FileManager sharedFileManager].gameCenterManager;
        gkHelper.delegate = self;
        
        CCSprite *background = [CCSprite spriteWithFile:@"bg/main/bg_main.png"];
        background.anchorPoint = ccp(0.5, 0);
        background.position = ccp(size.width / 2, 0);
        [self addChild:background z:-3];
        
        CCSprite *background1 = [CCSprite spriteWithFile:@"bg/main/bg_main_01.png"];
        background1.anchorPoint = ccp(0.5, 0);
        background1.position = ccp(size.width / 2, 0);
        [self addChild:background1 z:-1];
        
        CCSprite *background2 = [CCSprite spriteWithFile:@"bg/main/bg_main_02.png"];
        background2.anchorPoint = ccp(0.5, 0);
        background2.position = ccp(size.width / 3, 0);
        [self addChild:background2 z:-2];
        
        CCMenuItem *startMenuItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_main_start_up.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_main_start_down.png"] block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[[MainScene alloc] init]];
        }];
        
        startMenuItem.position = ccp(size.width - startMenuItem.boundingBox.size.width, startMenuItem.boundingBox.size.height);
        
        CCSprite *startSprite = [CCSprite spriteWithSpriteFrameName:@"bt_main_start_up.png"];
        [startSprite setBlendFunc: (ccBlendFunc) { GL_SRC_ALPHA, GL_ONE }];
        startSprite.position = ccp(startMenuItem.boundingBox.size.width/2, startMenuItem.boundingBox.size.height/2);
        [startMenuItem addChild:startSprite z:-1];
        
        CCScaleTo *bigger = [CCScaleTo actionWithDuration:0.5 scaleX:1.05 scaleY:1.1];
        CCScaleTo *smaller = [CCScaleTo actionWithDuration:0.5 scaleX:1.0 scaleY:1.0];
        CCSequence *pulseSequence = [CCSequence actionOne:bigger two:smaller];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:pulseSequence];
        [startSprite runAction:repeat];
        
        CCMenuItem *gameCenterMenuItem = [CCMenuItemImage itemWithNormalImage:@"game-center-icon.jpg" selectedImage:@"game-center-icon.jpg" target:gkHelper selector:@selector(showLeaderboard)];

        gameCenterMenuItem.position = ccp(background.boundingBox.size.width - gameCenterMenuItem.boundingBox.size.width, background.boundingBox.size.height - gameCenterMenuItem.boundingBox.size.height);
        
        CCMenuItem *testMenuItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_main_help_up.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_main_help_down.png"] block:^(id sender) {
                    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc.plist"];
                    [[CCDirector sharedDirector] replaceScene:[[BattleController alloc] initWithPrefix:1 suffix:1]];
//[[CCDirector sharedDirector] replaceScene:[ExampleLayer scene]];
            
        }];
        
        testMenuItem.position=ccp(testMenuItem.boundingBox.size.width,testMenuItem.boundingBox.size.height);
        
        CCAction *shake = [CCShake actionWithDuration:5.0 amplitude:ccp(5, 5)];
        [self runAction:shake];
        
        CCMenu *menu = [CCMenu menuWithItems:gameCenterMenuItem, startMenuItem,testMenuItem, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];
	}
	return self;
}

@end
