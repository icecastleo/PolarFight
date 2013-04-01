//
//  PauseLayer.m
//  LightBugBattle
//
//  Created by  浩翔 on 13/1/14.
//
//

#import "PauseLayer.h"
#import "HelloWorldLayer.h"
#import "FileManager.h"
#import "SimpleAudioEngine.h"

typedef enum {
    buttomPad1 = 0,
    buttomPad2,
    restartLabelY,
    resumeLabelY,
    topPad,
    labelsCount
} MenuLabelsPosition;

@interface PauseLayer () {
    CCMenu *menu;
}

@end

@implementation PauseLayer

-(id)init {
    if ((self = [super initWithColor:ccc4(50, 50, 50, 150)])) {
        [self gamePause];
        [self setOptionView];
        self.isTouchEnabled = YES;
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    [menu setHandlerPriority:kTouchPriotiryPause - 1];
}

-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kTouchPriotiryPause swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void)setOptionView {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *optionImage = [[CCSprite alloc] initWithFile:@"bg/bg_option.png"];
    optionImage.position = ccp(winSize.width/2, winSize.height/2);
    
    CCMenuItem *bgmOnItem = [CCMenuItemImage
                                 itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_bgmon_up.png"]
                                 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_bgmon_down.png"]
                                 target:nil selector:nil];
    CCMenuItem *bgmOffItem = [CCMenuItemImage
                   itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_bgmoff_up.png"]
                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_bgmoff_down.png"]
                   target:nil selector:nil];
    
    CCMenuItemToggle *bgmToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                                selector:@selector(switchBackgroundMusic)
                                                                   items:bgmOnItem, bgmOffItem, nil];
    CCMenuItem *effectOnItem = [CCMenuItemImage
                               itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_fxon_up.png"]
                               selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_fxon_down.png"]
                               target:nil selector:nil];
    CCMenuItem *effectOffItem = [CCMenuItemImage
                                itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_fxoff_up.png"]
                                selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_fxoff_down.png"]
                                target:nil selector:nil];
    
    CCMenuItemToggle *effectToggleItem = [CCMenuItemToggle itemWithTarget:self
                                                              selector:@selector(switchSoundsEffect)
                                                                 items:effectOnItem, effectOffItem, nil];
    
    CCMenuItemImage *giveUpMenuItem = [CCMenuItemImage
                                  itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_giveup_up.png"]
                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_giveup_down.png"]
                                  target:self selector:@selector(restartTapped)];
    
    CCMenuItemImage *continueMenuItem = [CCMenuItemImage
                                  itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_continue_up.png"]
                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_continue_down.png"]
                                    target:self selector:@selector(resumeTapped)];
    
    float width = optionImage.position.x - bgmToggleItem.boundingBox.size.width;
    float height = optionImage.position.y;
    
    bgmToggleItem.position = ccp(width, height);
    
    width = optionImage.position.x + effectToggleItem.boundingBox.size.width;
    
    effectToggleItem.position = ccp(width, height);
    
    width = optionImage.position.x - giveUpMenuItem.boundingBox.size.width/2;
    height = optionImage.position.y - optionImage.boundingBox.size.height/2 +giveUpMenuItem.boundingBox.size.height/2;
    
    giveUpMenuItem.position = ccp(width, height);
    
    width = optionImage.position.x + continueMenuItem.boundingBox.size.width/2;
    
    continueMenuItem.position = ccp(width, height);
    
    if([SimpleAudioEngine sharedEngine].backgroundMusicVolume == 0){
        [bgmToggleItem setSelectedIndex:bgmToggleItem.subItems.count - 1];
    }
    if([SimpleAudioEngine sharedEngine].effectsVolume == 0){
        [effectToggleItem setSelectedIndex:effectToggleItem.subItems.count - 1];
    }
    
    menu = [CCMenu menuWithItems:bgmToggleItem, effectToggleItem, giveUpMenuItem, continueMenuItem, nil];
    menu.position = CGPointZero;
    [self addChild:menu z:1];
    
    [self addChild:optionImage];
}

-(void)switchBackgroundMusic {
    [[FileManager sharedFileManager] switchBackgroundMusic];
}

-(void)switchSoundsEffect {
    [[FileManager sharedFileManager] switchSoundsEffect];
}

-(void)gamePause {
    [[CCDirector sharedDirector] pause];
}

-(void)resumeTapped {
    [[CCDirector sharedDirector] resume];
    [self removeFromParentAndCleanup:YES];
}

-(void)restartTapped {
    [[CCDirector sharedDirector] resume];
    
    // Reload the current scene
    CCScene *scene = [HelloWorldLayer scene];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:scene]];
}

@end
