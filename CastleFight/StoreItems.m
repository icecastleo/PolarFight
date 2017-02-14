//
//  StoreItems.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/24.
//
//

#import "StoreItems.h"
#import "CCScrollNode.h"
#import "FileManager.h"
#import "ItemSprite.h"

@interface StoreItems() {
    CCScrollNode *scrollingNode;
}

@end

@implementation StoreItems

-(id)initWithRect:(CGRect)rect {
    if (self = [super init]) {
        
        scrollingNode = [[CCScrollNode alloc] initWithRect:rect];
        //        scrollingNode.adjustPosition = YES;
        
        CCScrollView *scrollView = scrollingNode.scrollView;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollView.bounces = NO;
        scrollView.tag = noDisableVerticalScrollTag;
        
        CCScissorLayer *layer = [[CCScissorLayer alloc] initWithRect:rect];
        layer.horizontalScissor = NO;
        [layer addChild:scrollingNode];
        [self addChild:layer];
        
        NSArray *itemDatas = [FileManager sharedFileManager].items;
        
//        for (int i = 0; i < characterInitDatas.count; i++) {
//            CharacterInitData *data = characterInitDatas[i];
//            Entity *entity = [entityFactory createCharacter:data.cid level:data.level forTeam:1];
//            
//            CCSprite *temp = [[ShopUnitSprite alloc] initWithEntity:entity characterInitData:data];
//            temp.anchorPoint = ccp(0, 1);
//            temp.position = ccp(0, -temp.boundingBox.size.height * i);
//            [scrollingNode addChild:temp];
//        }
        
        int count = 4;
        
        for (int i = 0; i < count; i++) {
            CCSprite *item = [[ItemSprite alloc] init];
            item.anchorPoint = ccp(0, 1);
            item.position = ccp(0, -item.boundingBox.size.height * i);
            
            [scrollingNode addChild:item];
        }
        
        CCSprite *temp = [scrollingNode.children lastObject];
        
        //        CGSize contentSize = CGSizeMake(temp.contentSize.width, temp.boundingBox.size.height * characterInitDatas.count);
        CGSize contentSize = CGSizeMake(rect.size.width, temp.boundingBox.size.height * count);
        scrollingNode.scrollView.contentSize = contentSize;
    }
    return self;
}


@end
