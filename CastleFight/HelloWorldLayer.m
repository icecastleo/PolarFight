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
#import "ObjectiveCAdaptor.h"

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
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World Label!" fontName:@"Marker Felt" fontSize:32];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/4 * 3);
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		// Default font size will be 20 points.
		[CCMenuItemFont setFontSize:20];
		
		CCMenuItem *defaultMenu = [CCMenuItemFont itemWithString:@"Battle Scene" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[BattleController node]];
        }];
        
        CCMenuItem *selectScene = [CCMenuItemFont itemWithString:@"Select Scene" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[SelectLayer node]];
        }];
        
        
        // Jump Test Code
        
//        CCSprite *sprite = [CCSprite spriteWithFile:@"Bomb_01.png"];
//        sprite.position = ccp(50, 50);
//        [self addChild:sprite];
//        
//        CCMenuItem *zTest = [CCMenuItemFont itemWithString:@"zTest" block:^(id sender) {
//
//            CCActionInterval *jump = [CCSpawn actions: [CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:0.6 position:ccp(40, 10)] rate:1.5], nil];
//
//            CCSprite *s = [CCSprite spriteWithFile:@"blood_red.png"];
//            
//            CCAnimation *animation = [CCAnimation animationWithSpriteFrames:@[[CCSpriteFrame frameWithTexture:s.texture rect:s.textureRect]] delay:0.6];
//            animation.restoreOriginalFrame = YES;
//            CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
//            
//            CCSprite *test = [CCSprite spriteWithFile:@"Bomb_01.png"];
//            test.position = ccp(sprite.boundingBox.size.width / 2, sprite.boundingBox.size.height / 2);
//            [sprite addChild:test];
//
//            [test runAction:[CCSequence actions:[CCEaseOut actionWithAction:[CCMoveBy actionWithDuration:0.3 position:ccp(0, 125)] rate:3], [CCEaseIn actionWithAction: [CCMoveBy actionWithDuration:0.3 position:ccp(0, -125)] rate:3],[CCFadeOut actionWithDuration:0.01], nil]];
//            
//            [sprite runAction:[CCSpawn actions:jump, animate, nil] ];
//        }];
//        
//        [self runAction:[CCFollow actionWithTarget:sprite]];
//        
//        [self addChild:[CCSprite spriteWithFile:@"map.png"] z:-1];
//        
//		CCMenu *menu = [CCMenu menuWithItems:defaultMenu, selectScene, zTest, nil];
		
        CCMenu *menu = [CCMenu menuWithItems:defaultMenu, selectScene, nil];
        
        [menu alignItemsVerticallyWithPadding:30];
		[menu setPosition:ccp(size.width/2, size.height/2 - 20)];
		
		// Add the menu to the layer
		[self addChild:menu];
        
        // Test for c++ code
//        ObjectiveCAdaptor *test = [[ObjectiveCAdaptor alloc] init];
//        [test objectiveFunc];
        
	}
	return self;
}



// on "dealloc" you need to release all your retained objects

@end
