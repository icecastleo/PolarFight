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
#import "MarketLayer.h"
#import "StageScrollLayer.h"
#import "TapjoyConnect.h"
#import "AppDelegate.h"
#import "InAppPurchaseManager.h"

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
        
        moneyLabel = [[CCLabelBMFont alloc] initWithString:@"" fntFile:@"font/jungle_24_o.fnt"];
        moneyLabel.anchorPoint = ccp(1, 0.5);
        moneyLabel.scale = 0.5;
        moneyLabel.position = ccp(money.boundingBox.size.width - 6, money.boundingBox.size.height / 2);
        [money addChild:moneyLabel];
        
        __weak MainScene *copy_scene = scene;
        
        CCMenuItem *back = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_back_up.png"]
                                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_back_down.png"]
                                                            block:^(id sender) {
                                                                [copy_scene back];
                                                            }];
        back.anchorPoint = ccp(0, 0.5);
        back.position = ccp(0, background.boundingBox.size.height / 2);
        
        CCMenuItem *next = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_next_up.png"]
                                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_next_down.png"]
                                                            block:^(id sender) {
                                                                [copy_scene next];
                                                            }];
        next.anchorPoint = ccp(1, 0.5);
        next.position = ccp(background.boundingBox.size.width, background.boundingBox.size.height / 2);
        
        __weak id self_copy = self;
        
        CCMenuItem *market = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_shop_get_up.png"]
                                                    selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_shop_get_down.png"]
                                                            target:self_copy selector:@selector(clickGet:)];
        
        market.position = ccp(background.boundingBox.size.width / 10 * 2.25, background.boundingBox.size.height / 2);
        
        CCMenuItem *free = [CCMenuItemSprite itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_shop_tapjoy_up.png"]
                                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_shop_tapjoy_down.png"]
                                                            block:^(id sender) {
                                                                  [TapjoyConnect getTapPoints];
                                                                [TapjoyConnect showOffersWithViewController:[CCDirector sharedDirector]];
                                                            }];
        free.position = ccp(background.boundingBox.size.width / 10 * 3.25, background.boundingBox.size.height / 2);
        
        CCMenu *menu = [CCMenu menuWithItems:back, next, market, free, nil];
        menu.position = ccp(0, 0);
        
        // Because it is out from a scissor layer range!
        [menu setTouchPriority:kCCScissorLayerTouchPriority-1];
        
        [background addChild:menu];
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMoneyLabel:) name:@"MoneyChangedNotify" object:nil];
    [self updateMoneyLabel:nil];
}

-(void)onExit {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"MoneyChangedNotify" object:nil];
    [super onExit];
}

-(void)updateMoneyLabel:(NSNotification *)sender {
    [moneyLabel setString:[NSString stringWithFormat:@"%d",[FileManager sharedFileManager].userMoney]];
}

-(void)clickGet:(id)sender {
    [[InAppPurchaseManager sharedManager] sendProductRequest:self];
    
    baseAlert = [[UIAlertView alloc]
                  initWithTitle:NSLocalizedString(@"Please Wait", nil) message:nil
                  delegate:self cancelButtonTitle:nil
                  otherButtonTitles: nil];
    [baseAlert show];
    
    // Create and add the activity indicator
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    indicator.center = ccp(baseAlert.bounds.size.width/2, baseAlert.bounds.size.height - 40);
    [indicator startAnimating];
    [baseAlert addSubview:indicator];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    [baseAlert dismissWithClickedButtonIndex:baseAlert.cancelButtonIndex animated:NO];
    baseAlert = nil;
    
    NSArray *products = response.products;
    
    for (NSString *invalidProductId in response.invalidProductIdentifiers) {
        CCLOG(@"Invalid product id: %@" , invalidProductId);
    }
    
    NSAssert(response.invalidProductIdentifiers.count == 0, @"Product identifier error!!");
    
    [[CCDirector sharedDirector] pushScene:[MarketLayer sceneWithProducts:products]];
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    [baseAlert dismissWithClickedButtonIndex:baseAlert.cancelButtonIndex animated:NO];
    baseAlert = nil;
    
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:nil
                                                        message:NSLocalizedString(@"Cannot connect to iTunes Store", nil)
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
    
    [alerView show];
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
