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

@interface BattleStatusLayer() {
    CharacterQueueLayer *queueLayer;
}
@end

@implementation BattleStatusLayer
@synthesize queue = _queue;

static const int pauseLayerTag = 9999;

-(id) initWithBattleController:(BattleController *) battleController andQueue:(CharacterQueue *)aQueue{
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
        
        _queue = aQueue;
        [self setPauseButton];
        [self setCharacatQueueLayer];
        // TODO: init other view like playing queue.
    }
    return self;
}

-(void) startSelectCharacter:(Character*)character {
    [self setCurrentCharacterInQueueLayer:character];
    [character.sprite addChild:selectSprite];
    selectSprite.position = ccp(character.boundingBox.size.width / 2, character.boundingBox.size.height / 2);
    [selectSprite runAction:selectAction];
    selectSprite.visible = YES;
}

-(void) stopSelect {
    [selectSprite removeFromParentAndCleanup:NO];
    selectSprite.visible = NO;
    [selectSprite stopAllActions];
}

-(void)pauseButtonTapped:(id)sender {
    if(![self getChildByTag:pauseLayerTag]){
        PauseLayer *layer = [PauseLayer node];
        layer.tag = pauseLayerTag;
        [self addChild:layer];
    }
}

-(void)setPauseButton {
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

-(void)setCharacatQueueLayer {
    queueLayer = [[CharacterQueueLayer alloc] initWithQueue:self.queue];
    [self addChild:queueLayer];
}

-(void)setCurrentCharacterInQueueLayer:(Character *)character {
    [queueLayer setCurrentCharacter:character];
}
@end
