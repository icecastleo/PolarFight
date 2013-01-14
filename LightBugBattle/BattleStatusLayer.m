//
//  StatusLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleStatusLayer.h"

@implementation BattleStatusLayer

-(id) initWithBattleController:(BattleController *) battleController {
    if(self = [super init]) {        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        _countdownLabel = [[CCLabelBMFont alloc] initWithString:@"Loading..." fntFile:@"TestFont.fnt"];
        _countdownLabel.position = ccp(size.width / 2, size.height - 30);
        [self addChild:_countdownLabel];
        
        _startLabel = [CCLabelTTF labelWithString:@"Press to start!"  fontName:@"Marker Felt"  fontSize:21];
        _startLabel.position = ccp(size.width / 2,size.height / 2);
        _startLabel.opacity = 150;
//        startLabel.visible = NO;
        [self addChild:_startLabel];
        
        selectSprite = [[CCSprite alloc] init];
        selectSprite.visible = NO;
        
        CCAnimation *animation = [CCAnimation animation];
        
        [animation addSpriteFrameWithFilename:@"select-1.png"];
        [animation addSpriteFrameWithFilename:@"select-2.png"];
        [animation addSpriteFrameWithFilename:@"select-3.png"];
        animation.restoreOriginalFrame = NO;
        animation.delayPerUnit = 0.25;
        
        CCAnimate *selectAnimate = [[CCAnimate alloc] initWithAnimation:animation];
        selectAction = [CCRepeatForever actionWithAction:selectAnimate];
        
        // TODO: init other view like playing queue.
    }
    return self;
}

-(void) startSelectCharacter:(Character*)character {
//    Select sprite should be on the same layer as the character is.
    [character.sprite.parent addChild:selectSprite];
    selectSprite.position = character.position;
    [selectSprite runAction:selectAction];
    selectSprite.visible = YES;    
}

-(void) stopSelect {
    [selectSprite removeFromParentAndCleanup:NO];
    selectSprite.visible = NO;
    [selectSprite stopAllActions];
}

@end
