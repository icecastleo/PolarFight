//
//  ShopLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/29.
//
//

#import "ShopLayer.h"
#import "CCScrollingNode.h"
#import "CCScissorLayer.h"

@implementation ShopLayer

-(id)init {
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:@"bg/shop/bg_shop_back.png"];
        background.anchorPoint = ccp(0, 0);
        [self addChild:background];
        
        CCMenuItemImage *unit = [[CCMenuItemImage alloc]
                                 initWithNormalSprite:[CCSprite spriteWithSpriteFrameName:@"bt_unit_on_up.png"]
                                 selectedSprite:[CCSprite spriteWithSpriteFrameName:@"bt_unit_on_down.png"]
                                 disabledSprite:nil
                                 block:^(id sender) {
                                     
                                 }];


        CGRect rect = CGRectMake(0, 0, winSize.width, winSize.height - 50);
        
        CCScissorLayer *layer = [[CCScissorLayer alloc] initWithRect:rect];
        CCScrollingNode *scrollingNode = [[CCScrollingNode alloc] initWithRect:rect];
        [layer addChild:scrollingNode];
        [self addChild:layer];

        for(NSInteger i = 0; i <= 50; i++) {
            CCLabelTTF *label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", i]
                                                   fontName:@"Marker Felt"
                                                   fontSize:64];
            label.anchorPoint = ccp(0.5, 1.0);
            label.position = ccp(winSize.width * 0.5, winSize.height + i * -75);
            [scrollingNode addChild:label];
        }
        
        CCNode *lastNode = [scrollingNode.children lastObject];
        //        CGSize contentSize = CGSizeMake(lastNode.contentSize.width, winSize.height - 120 - lastNode.position.y + lastNode.contentSize.height);
        CGSize contentSize = CGSizeMake(lastNode.contentSize.width, 51 * 75);
        scrollingNode.scrollView.contentSize = contentSize;

    }
    return self;
}

@end
