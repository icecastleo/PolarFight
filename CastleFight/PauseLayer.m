//
//  PauseLayer.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/14.
//
//

#import "PauseLayer.h"
#import "HelloWorldLayer.h"

typedef enum {
    buttomPad1 = 0,
    buttomPad2,
    restartLabelY,
    resumeLabelY,
    topPad,
    labelsCount
} MenuLabelsPosition;

@implementation PauseLayer

-(id)init {
    if ((self = [super initWithColor:ccc4(50, 50, 50, 150)])) {
        [self showPauseMenu];
        
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    [menu setHandlerPriority:kTouchPriotiryPause - 1];
}

-(void)showPauseMenu {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    
    CCLabelTTF *restartLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        restartLabel = [CCLabelBMFont labelWithString:@"Restart" fntFile:@"WhiteFont.fnt"];
    } else {
        restartLabel = [CCLabelTTF labelWithString:@"Restart" fontName:@"Marker Felt" fontSize:40];
        restartLabel.color = ccBLACK;
    }
    
    CCMenuItemLabel *restartItem = [CCMenuItemLabel itemWithLabel:restartLabel target:self selector:@selector(restartTapped:)];
    restartItem.scale = 1.0;
    restartItem.position = ccp(winSize.width/2, winSize.height*restartLabelY/labelsCount);
    
    CCLabelTTF *resumeLabel;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        resumeLabel = [CCLabelBMFont labelWithString:@"Resume" fntFile:@"WhiteFont.fnt"];
    } else {
        resumeLabel = [CCLabelTTF labelWithString:@"Resume" fontName:@"Marker Felt" fontSize:40];
        resumeLabel.color = ccBLACK;
    }
    
    CCMenuItemLabel *resumetItem = [CCMenuItemLabel itemWithLabel:resumeLabel target:self selector:@selector(resumeTapped:)];
    resumetItem.scale = 1.0;
    resumetItem.position = ccp(winSize.width/2, winSize.height*resumeLabelY/labelsCount);
    
    menu = [CCMenu menuWithItems:restartItem, resumetItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:10];
    
    [self gamePause];
}

-(void)gamePause {
    [[CCDirector sharedDirector] pause];
}

-(void)resumeTapped:(id)sender {
    [[CCDirector sharedDirector] resume];
    [self removeFromParentAndCleanup:YES];
}

-(void)restartTapped:(id)sender {
    [[CCDirector sharedDirector] resume];
    
    // Reload the current scene
    CCScene *scene = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
}

-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kTouchPriotiryPause swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

@end
