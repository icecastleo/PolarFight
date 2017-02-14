//
//  StoreUnits.m
//  CastleFight
//
//  Created by 朱 世光 on 2013/10/28.
//
//

#import "StoreUnits.h"
#import "CCScrollNode.h"
#import "FileManager.h"
#import "StoreUnitSprite.h"

@interface StoreUnits() {
    CCScrollNode *scrollingNode;
}

@end

@implementation StoreUnits

-(id)initWithRect:(CGRect)rect {
    if (self = [super init]) {
        
        scrollingNode = [[CCScrollNode alloc] initWithRect:rect];
        //        scrollingNode.adjustPosition = YES;
        
        CCScrollView *scrollView = scrollingNode.scrollView;
        scrollView.showsVerticalScrollIndicator = YES;
        scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
//        scrollView.pagingEnabled = YES;
        scrollView.bounces = NO;
        scrollView.tag = noDisableVerticalScrollTag;
        
        
//        CCScissorLayer *layer = [[CCScissorLayer alloc] initWithRect:rect];
//        layer.horizontalScissor = NO;
//        [layer addChild:scrollingNode];
//        [self addChild:layer];
        
        [self addChild:scrollingNode];
        
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
        
        int count = 7;
        
        for (int i = 0; i < count; i++) {
            CCSprite *item = [[StoreUnitSprite alloc] init];
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
