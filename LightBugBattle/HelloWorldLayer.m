//
//  HelloWorldLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"
#import "BattleLayer.h"
#import "MapControlExample.h"
// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

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
            [[CCDirector sharedDirector] replaceScene:[BattleLayer scene]];
        }];
		
        CCMenuItem *mapItem = [CCMenuItemFont itemWithString:@"MapCameraTest" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[MapControlExample scene]];
        }];
        
		CCMenu *menu = [CCMenu menuWithItems:defaultMenu, mapItem, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 )];
		
		// Add the menu to the layer
		[self addChild:menu];
        
	}
	return self;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
