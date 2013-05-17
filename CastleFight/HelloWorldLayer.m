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
#import "SelectLayer.h"
#import "StageLayer.h"
#import "MainScene.h"
#import "FileManager.h"

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
        
        CCMenuItem *startMenuItem = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_main_start_up.png"] selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_main_start_down.png"] block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[[MainScene alloc] init]];
        }];
        
        float width = size.width - startMenuItem.boundingBox.size.width;
        float height = startMenuItem.boundingBox.size.height;
        startMenuItem.position = ccp(width, height);
        
        CCMenuItem *gameCenterMenuItem = [CCMenuItemImage itemWithNormalImage:@"game-center-icon.jpg" selectedImage:@"game-center-icon.jpg" target:gkHelper selector:@selector(showLeaderboard)];
        width = size.width - gameCenterMenuItem.boundingBox.size.width;
        height = size.height - gameCenterMenuItem.boundingBox.size.height;
        gameCenterMenuItem.position = ccp(width, height);
        
        CCMenu *menu = [CCMenu menuWithItems:gameCenterMenuItem, startMenuItem, nil];
        menu.position = CGPointZero;
        
        [self addChild:menu];
        
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
        
	}
	return self;
}

@end
