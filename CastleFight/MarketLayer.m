//
//  MarketLayer.m
//  CastleFight
//
//  Created by 陳 謙 on 13/4/9.
//
//

#import "MarketLayer.h"
#import "InAppPurchaseManager.h"
#import "CCMenu+RowColumnExtend.h"

@implementation MarketLayer

+(CCScene *)sceneWithProducts:(NSArray *)products
{
	CCScene *scene = [CCScene node];
	
	MarketLayer *layer = [[MarketLayer alloc] initWithProducts:products];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id)initWithProducts:(NSArray *)array {
    if (self = [super init]) {
        products = array;
        
        for (SKProduct *product in products) {
            CCLOG(@"Product title: %@" , product.localizedTitle);
            CCLOG(@"Product description: %@" , product.localizedDescription);
            CCLOG(@"Product price: %@", product.localizedPrice);
            CCLOG(@"Product id: %@" , product.productIdentifier);
        }
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"bg/shop/bg_market.png"];
        background.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:background];
        
        CCMenuItem *buy1 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                           block:^(id sender) {
                                                               [self buy:0];
                                                           }];
        buy1.position = ccp(background.boundingBox.size.width*8/20, background.boundingBox.size.height*13/20);
        
        CCMenuItem *buy2 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                           block:^(id sender) {
                                                               [self buy:1];
                                                           }];
        buy2.position = ccp(background.boundingBox.size.width*17/20, background.boundingBox.size.height*13/20);
        
        
        CCMenuItem *buy3 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                           block:^(id sender) {
                                                               [self buy:2];
                                                           }];
        buy3.position = ccp(background.boundingBox.size.width*8/20, background.boundingBox.size.height*10/20);
        
        CCMenuItem *buy4 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                           block:^(id sender) {
                                                               [self buy:3];
                                                           }];
        buy4.position = ccp(background.boundingBox.size.width*17/20, background.boundingBox.size.height*10/20);
        
        CCMenuItem *buy5 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                           block:^(id sender) {
                                                               [self buy:4];
                                                           }];
        buy5.position = ccp(background.boundingBox.size.width*8/20, background.boundingBox.size.height*7/20);
        
        CCMenuItem *buy6 = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_up.png"]
                                                  selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_buy_down.png"]
                                                           block:^(id sender) {
                                                               [self buy:5];
                                                           }];
        buy6.position = ccp(background.boundingBox.size.width*17/20, background.boundingBox.size.height*7/20);
        
        
        CCMenuItem *close = [CCMenuItemImage itemWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_close_up.png"]
                                                   selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_close_down.png"]
                                                            block:^(id sender) {
                                                                [self close];
                                                            }];
        close.position = ccp(background.boundingBox.size.width/2, background.boundingBox.size.height*1/5);
        
        CCMenu *menu = [CCMenu menuWithItems:buy1, buy2, buy3, buy4, buy5, buy6, close, nil];
        menu.position = ccp(0, 0);
        [background addChild:menu];
        
        NSArray *contents = [InAppPurchaseManager sharedManager].productContents;
        
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle]; // this line is important!
        
        for (int i = 0; i < products.count; i++) {
            CGPoint position = ((CCNode *)[menu.children objectAtIndex:i]).position;
                        
            CCLabelBMFont *content = [[CCLabelBMFont alloc] initWithString:[formatter stringFromNumber:[NSNumber numberWithInt:[contents[i] intValue]]] fntFile:@"font/jungle_24_o.fnt"];
            content.anchorPoint = ccp(1, 0);
            content.scale = 0.75;
            content.position = ccp(position.x - 40, position.y - 5);
            [background addChild:content];
            
            CCLabelBMFont *price = [[CCLabelBMFont alloc] initWithString:((SKProduct *)products[i]).localizedPrice fntFile:@"font/jungle_24_o.fnt"];
            price.anchorPoint = ccp(1, 1);
            price.scale = 0.375;
            price.position = ccp(position.x - 40, position.y - 5);
            [background addChild:price];
        }
    }
    return self;
}

-(void)close {
    [[CCDirector sharedDirector] popScene];
}

-(void)buy:(int)type {
    [[InAppPurchaseManager sharedManager] buyProduct:products[type]];
}

@end
