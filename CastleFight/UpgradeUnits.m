//
//  StoreUnits.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/21.
//
//

#import "UpgradeUnits.h"
#import "EntityManager.h"
#import "EntityFactory.h"
#import "CCScrollNode.h"
#import "FileManager.h"
#import "CharacterInitData.h"
#import "ShopUnitSprite.h"

@interface UpgradeUnits() {
    EntityManager *entityManager;
    EntityFactory *entityFactory;
    
    CCScrollNode *scrollingNode;
}

@end

@implementation UpgradeUnits

-(id)initWithRect:(CGRect)rect {
    if (self = [super init]) {
        entityManager = [[EntityManager alloc] init];
        entityFactory = [[EntityFactory alloc] initWithEntityManager:entityManager];
        
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
        
        NSArray *characterInitDatas = [FileManager sharedFileManager].characterInitDatas;
        
        for (int i = 0; i < characterInitDatas.count; i++) {
            CharacterInitData *data = characterInitDatas[i];
            Entity *entity = [entityFactory createCharacter:data.cid level:data.level forTeam:1];
            
            CCSprite *temp = [[ShopUnitSprite alloc] initWithEntity:entity characterInitData:data];
            temp.anchorPoint = ccp(0, 1);
            temp.position = ccp(0, -temp.boundingBox.size.height * i);
            [scrollingNode addChild:temp];
        }
        
        CCSprite *temp = [scrollingNode.children lastObject];
        
//        CGSize contentSize = CGSizeMake(temp.contentSize.width, temp.boundingBox.size.height * characterInitDatas.count);
        CGSize contentSize = CGSizeMake(rect.size.width, temp.boundingBox.size.height * characterInitDatas.count);
        scrollingNode.scrollView.contentSize = contentSize;
    }
    return self;
}

@end
