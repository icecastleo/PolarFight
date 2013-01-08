//
//  StatusLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleStatusLayer.h"

@implementation BattleStatusLayer

@synthesize startLabel,countdownLabel;

-(id) initWithBattleController:(BattleController *) battleController {

    if(self = [super init]) {
    
//        controller = battleController;
        
        CGSize size = [CCDirector sharedDirector].winSize;
        
        countdownLabel = [[CCLabelBMFont alloc] initWithString:@"Loading..." fntFile:@"TestFont.fnt"];
        countdownLabel.position = ccp(size.width / 2, size.height - 30);
        [self addChild:countdownLabel];
        
        startLabel = [CCLabelTTF labelWithString:@"Press to start!"  fontName:@"Marker Felt"  fontSize:21];
        startLabel.position = ccp(size.width / 2,size.height / 2);
        startLabel.opacity = 150;
//        startLabel.visible = NO;
        [self addChild:startLabel];
        
        
        selectSprite = [[CCSprite alloc] init];
        selectSprite.visible = NO;
//        [self addChild:selectSprite];
        
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

//-(void) update:(ccTime) delta {
//
//    // TODO: update label;
//}

@end
