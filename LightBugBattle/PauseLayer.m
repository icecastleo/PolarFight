//
//  PauseLayer.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/14.
//
//

#import "PauseLayer.h"
#import "HelloWorldLayer.h"

@implementation PauseLayer

-(id)init {
    
    if ((self = [super init])) {
        [self setPauseButton];
    }
    return self;
}

- (void)restartTapped:(id)sender {
    
    // Reload the current scene
    CCScene *scene = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
    
}

- (void)showPauseMenu {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCLabelTTF *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"WhiteFont.fnt"];
    } else {
        restartLabel = [CCLabelTTF labelWithString:@"Restart" fontName:@"Marker Felt" fontSize:60];
        restartLabel.color = ccBLACK;
    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 0.1;
    restartItem.position = ccp(winSize.width/2, winSize.height/2);
    
    CCMenu *menu = [CCMenu menuWithItems:restartItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:10];
    
    [restartItem runAction:[CCScaleTo actionWithDuration:0.5 scale:1.0]];
}

- (void)pauseButtonTapped:(id)sender {
    [self showPauseMenu];
}

- (void)setPauseButton {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCMenuItem *pauseMenuItem = [CCMenuItemImage
                                itemWithNormalImage:@"ButtonPause.png" selectedImage:@"ButtonPauseSel.png"
                                target:self selector:@selector(pauseButtonTapped:)];
    
    double width = winSize.width - pauseMenuItem.boundingBox.size.width/2;
    double height = winSize.height - pauseMenuItem.boundingBox.size.height/2;
    pauseMenuItem.position = ccp(width, height);
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
    pauseMenu.position = CGPointZero;
    [self addChild:pauseMenu];
}

@end
