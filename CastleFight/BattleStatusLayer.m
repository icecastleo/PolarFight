//
//  StatusLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleStatusLayer.h"
#import "PauseLayer.h"
#import "CharacterQueueLayer.h"
#import "CharacterQueue.h"

@implementation BattleStatusLayer

-(id)initWithBattleController:(BattleController *)battleController {
    if(self = [super init]) {        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        // set start label
        _startLabel = [CCLabelTTF labelWithString:@"Start!!"  fontName:@"Marker Felt"  fontSize:36];
        _startLabel.position = ccp(size.width / 2, size.height / 2);
        _startLabel.opacity = 150;
        [self addChild:_startLabel];
        
        [_startLabel runAction:[CCSequence actions:
                                [CCFadeOut actionWithDuration:2.0f],
                                [CCCallFuncN actionWithTarget:self selector:@selector(removeSelf:)],
                                nil]];

        [self setPauseButton];
    }
    return self;
}

-(void)removeSelf:(id)sender {
    CCNode *node = (CCNode *)sender;
    
    [node removeFromParentAndCleanup:YES];
}

-(void)setPauseButton {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCMenuItem *pauseMenuItem = [CCMenuItemImage
                                 itemWithNormalImage:@"ButtonPause.png" selectedImage:@"ButtonPauseSel.png"
                                 target:self selector:@selector(pauseButtonTapped:)];
    
    float width = winSize.width - pauseMenuItem.boundingBox.size.width/2;
    float height = winSize.height - pauseMenuItem.boundingBox.size.height/2;
    pauseMenuItem.position = ccp(width, height);
    
    CCMenu *pauseMenu = [CCMenu menuWithItems:pauseMenuItem, nil];
    pauseMenu.position = CGPointZero;
    [self addChild:pauseMenu];
}

-(void)pauseButtonTapped:(id)sender {
    [self addChild:[PauseLayer node]];
}

-(void)winTheGame:(BOOL)win {
    CCLabelTTF *gameOverLabel;
    if (win) {
        gameOverLabel = [CCLabelTTF labelWithString:@"You Win!"  fontName:@"Marker Felt"  fontSize:31];
    }else {
        gameOverLabel = [CCLabelTTF labelWithString:@"You Lose!"  fontName:@"Marker Felt"  fontSize:31];
    }
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    gameOverLabel.position = ccp(winSize.width/2,winSize.height/2+gameOverLabel.boundingBox.size.height);
    gameOverLabel.color = ccRED;
    [self addChild:gameOverLabel];
}

@end
