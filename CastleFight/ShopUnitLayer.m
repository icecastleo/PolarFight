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
#import "EntityManager.h"
#import "EntityFactory.h"    

@interface ShopUnitLayer() {
    EntityManager *entityManager;
    EntityFactory *entityFactory;
}

@end

@implementation ShopUnitLayer

-(id)init {
    if (self = [super init]) {
        entityManager = [[EntityManager alloc] init];
        entityFactory = [[EntityFactory alloc] initWithEntityManager:entityManager];
        
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
        
        NSArray *characterInitDatas = [FileManager sharedFileManager].characterInitDatas;
        
        for (int i = 0; i < characterInitDatas.count; i++) {
            CharacterInitData *data = characterInitDatas[i];
            Entity *entity = [entityFactory createCharacter:data.cid level:data.level forTeam:1];
            
            CCSprite *temp = [[ShopUnitSprite alloc] initWithEntity:entity characterInitData:data];
            temp.anchorPoint = ccp(0, 1);
            temp.position = ccp(winSize.width/2 - 240 + 76, winSize.height - 50 - temp.boundingBox.size.height * i);
            [scrollingNode addChild:temp];
        }
        
        CCSprite *temp = [scrollingNode.children lastObject];

        CGSize contentSize = CGSizeMake(temp.contentSize.width, temp.boundingBox.size.height * characterInitDatas.count);
        scrollingNode.scrollView.contentSize = contentSize;
    }
    return self;
}

@end
