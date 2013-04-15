//
//  MarketLayer.m
//  CastleFight
//
//  Created by 陳 謙 on 13/4/9.
//
//

#import "MarketLayer.h"
#import "InAppPurchaseManager.h"
#define ProductID_Test1 @"com.sayagain.moonfight.Test1"
#define ProductID_Test2 @"com.sayagain.moonfight.Test2"
#define ProductID_Test3 @"com.sayagain.moonfight.Test3"
#define ProductID_Test4 @"com.sayagain.moonfight.Test4"
#define ProductID_Test5 @"com.sayagain.moonfight.Test5"
#define ProductID_Test6 @"com.sayagain.moonfight.Test6" 
@implementation MarketLayer

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MarketLayer *layer = [MarketLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}



-(id)init {
    if (self = [super init]) {
          CGSize winSize = [CCDirector sharedDirector].winSize;
        if([[InAppPurchaseManager sharedManager] canMakePurchases])
        {
            
            [self prepareButtons];
        }
        else{
        
            UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                message:@"You can‘t purchase in app store"
                                                               delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
            
            [alerView show];
        }
    }
    return self;
}
-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kTouchPriotiryPause swallowsTouches:YES];
}
-(void)close
{
    [[CCDirector sharedDirector] popScene];
}
-(void)buy:(int)type
{
      NSArray *product = nil; 
    switch (type) {
        case 1:
            product=[[NSArray alloc] initWithObjects:ProductID_Test1,nil];
            break;
        case 2:
            product=[[NSArray alloc] initWithObjects:ProductID_Test2,nil];
            break;
        case 3:
            product=[[NSArray alloc] initWithObjects:ProductID_Test3,nil];
            break;
        case 4:
            product=[[NSArray alloc] initWithObjects:ProductID_Test4,nil];
            break;
        case 5:
            product=[[NSArray alloc] initWithObjects:ProductID_Test5,nil];
            break;
        case 6:
            product=[[NSArray alloc] initWithObjects:ProductID_Test6,nil];
            break;
        default:
            break;
    }
    NSSet *nsset = [NSSet setWithArray:product];
    SKProductsRequest *request=[[SKProductsRequest alloc] initWithProductIdentifiers: nsset];
    request.delegate=[InAppPurchaseManager sharedManager];
    [request start];
}

- (void)prepareButtons {
    CCSprite *background = [CCSprite spriteWithFile:@"bg/shop/bg_market.png"];
    background.anchorPoint = ccp(0, 0);
    [self addChild:background];
    
    CCMenuItem *close = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_close_up.png"]
                                               selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_close_down.png"]
                                                        block:^(id sender) {
                                                            [self close];
                                                        }];
    close.position = ccp(background.boundingBox.size.width/2, background.boundingBox.size.height* 1/ 5);
    CCMenuItem *buy1 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                              selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                       block:^(id sender) {
                                                           [self buy:1];
                                                       }];
    buy1.position = ccp(background.boundingBox.size.width*2/5, background.boundingBox.size.height* 13/ 20);
    
    CCMenuItem *buy2 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                              selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                       block:^(id sender) {
                                                           [self buy:2];
                                                       }];
    buy2.position = ccp(background.boundingBox.size.width*2/5, background.boundingBox.size.height/2);
    
    
    CCMenuItem *buy3 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                              selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                       block:^(id sender) {
                                                           [self buy:3];
                                                       }];
    buy3.position = ccp(background.boundingBox.size.width*2/5, background.boundingBox.size.height* 7/20);
    
    CCMenuItem *buy4 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                              selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                       block:^(id sender) {
                                                           [self buy:4];
                                                       }];
    buy4.position = ccp(background.boundingBox.size.width*17/20, background.boundingBox.size.height* 13/20);
    
    CCMenuItem *buy5 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                              selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                       block:^(id sender) {
                                                           [self buy:5];
                                                       }];
    buy5.position = ccp(background.boundingBox.size.width*17/20, background.boundingBox.size.height* 5/10);
    
    CCMenuItem *buy6 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                              selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                       block:^(id sender) {
                                                           [self buy:6];
                                                       }];
    buy6.position = ccp(background.boundingBox.size.width*17/20, background.boundingBox.size.height* 7/20);
    
    
    
    
    CCMenu *menu = [CCMenu menuWithItems:close,buy1,buy2,buy3,buy4,buy5,buy6, nil];
    menu.position = ccp(0, 0);
    [background addChild:menu];
}

@end
