//
//  MainStatusLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/1.
//
//

#import "MainStatusLayer.h"
#import "FileManager.h"
#import "HelloWorldLayer.h"
#import "StageScrollLayer.h"

@implementation MainStatusLayer

-(id)initWithMainScene:(MainScene *)scene {
    if (self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"button.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"shopbutton.plist"];
                
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"bg/shop/bg_shop_up.png"];
        background.position = ccp(winSize.width / 2, winSize.height - background.boundingBox.size.height / 2);
        [self addChild:background];
        
        CCSprite *money = [CCSprite spriteWithFile:@"bg/shop/bg_shop_bar.png"];
        money.position = ccp(background.boundingBox.size.width / 10 * 7.25, background.boundingBox.size.height / 2);
        [background addChild:money];
        
        CCLabelBMFont *moneyLabel = [[CCLabelBMFont alloc] initWithString:[NSString stringWithFormat:@"%d",[FileManager sharedFileManager].userMoney] fntFile:@"font/jungle_24_o.fnt"];
        moneyLabel.anchorPoint = ccp(1, 0.5);
        moneyLabel.scale = 0.5;
        moneyLabel.position = ccp(money.boundingBox.size.width - 6, money.boundingBox.size.height / 2);
        [money addChild:moneyLabel];
        
        CCMenuItem *back = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_back_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_back_down.png"]
                                                           block:^(id sender) {
                                                               [scene back];
                                                           }];
        back.anchorPoint = ccp(0, 0.5);
        back.position = ccp(0, background.boundingBox.size.height / 2);
        
        CCMenuItem *next = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_next_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_next_down.png"]
                                                           block:^(id sender) {
                                                               [scene next];
                                                           }];
        next.anchorPoint = ccp(1, 0.5);
        next.position = ccp(background.boundingBox.size.width, background.boundingBox.size.height / 2);
        
        CCMenuItem *get = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_shop_get_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_shop_get_down.png"]
                                                           block:^(id sender) {
                                                               ;
                                                           }];
        get.position = ccp(background.boundingBox.size.width / 10 * 2.25, background.boundingBox.size.height / 2);
        
        CCMenuItem *free = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_shop_tapjoy_up.png"]
                                                 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_shop_tapjoy_down.png"]
                                                          block:^(id sender) {
                                                              ;
                                                          }];
        free.position = ccp(background.boundingBox.size.width / 10 * 3.25, background.boundingBox.size.height / 2);
        
        CCMenu *menu = [CCMenu menuWithItems:back, next, get, free, nil];
        menu.position = ccp(0, 0);
        [background addChild:menu];
        
    }
    return self;
}

-(void)dealloc {
//    CCLOG(@"dealloc");
//    
//    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"button.plist"];
//    [[CCSpriteFrameCache sharedSpriteFrameCache] removeSpriteFramesFromFile:@"shopbutton.plist"];
//    
//#ifdef DEBUG
//    [[CCTextureCache sharedTextureCache] removeUnusedTextures];
//    [[CCTextureCache sharedTextureCache] dumpCachedTextureInfo];
//#endif
}

@end
