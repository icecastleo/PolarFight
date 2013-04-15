//
//  ShopUnitLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/8.
//
//

#import "ShopUnitLayer.h"
#import "FileManager.h"
#import "ShopUnitSprite.h"
#import "CCScrollNode.h"
#import "CCScissorLayer.h"

@implementation ShopUnitLayer

-(id)init {
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CGPoint origin = ccp(winSize.width/2 - 240 + 76, 0);
        CGRect rect = CGRectMake(origin.x, origin.y, 404, winSize.height - 50);
        
        CCScrollNode *scrollingNode = [[CCScrollNode alloc] initWithRect:rect];
//        scrollingNode.adjustPosition = YES;

        CCScrollView *scrollView = scrollingNode.scrollView;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollView.bounces = NO;
        scrollView.tag = noDisableVerticalScrollTag;
        
        CCScissorLayer *layer = [[CCScissorLayer alloc] initWithRect:rect];
        layer.isTouchEnabled = YES;
        [layer addChild:scrollingNode];
        [self addChild:layer];
        
        NSArray *characters = [[FileManager sharedFileManager] getChararcterArray];
        
        for (int i = 0; i < characters.count; i++) {
            CCSprite *temp = [[ShopUnitSprite alloc] initWithCharacter:characters[i]];
            temp.anchorPoint = ccp(0, 1);
            temp.position = ccp(winSize.width/2 - 240 + 76, winSize.height - 50 - temp.boundingBox.size.height * i);
            [scrollingNode addChild:temp];
        }
        
        CCSprite *temp = [scrollingNode.children lastObject];

        CGSize contentSize = CGSizeMake(temp.contentSize.width, temp.boundingBox.size.height * characters.count);
        scrollingNode.scrollView.contentSize = contentSize;
    }
    return self;
}

@end
