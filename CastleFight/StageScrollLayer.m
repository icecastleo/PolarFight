//
//  StageLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/29.
//
//

#import "StageScrollLayer.h"
#import "StageLayer.h"
#import "CCScissorLayer.h"

@implementation StageScrollLayer

-(id)init {
    //TODO: init by user stage info
    
    if (self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"selstagebutton.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc.plist"];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
//        CCNode *node = [[CCNode alloc] init];
//        node.anchorPoint = ccp(0, 0);
//        node.contentSize = CGSizeMake(winSize.width, 0);
//        [self addChild:node];
        
        NSMutableArray *backgrounds = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 5; i++) {
            CCLayer *layer = [[CCLayer alloc] init];
            CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bg/selectstage/bg_selectstage_map_%02d.png", i]];
            background.position = ccp(winSize.width / 2, winSize.height / 2);
            [layer addChild:background];
            [backgrounds addObject:layer];
        }
        
        backgroundLayer = [[CCScrollLayer alloc] initWithLayers:backgrounds widthOffset:0];
        backgroundLayer.showPagesIndicator = NO;
        backgroundLayer.isTouchEnabled = NO;
        [self addChild:backgroundLayer];
        
        CCLayerColor *color = [[CCLayerColor alloc] initWithColor:ccc4(50, 50, 50, 150)];
        [self addChild:color];
        
        CCScissorLayer *scissor = [[CCScissorLayer alloc] initWithRect:CGRectMake(40, 0, 400, 320)];
        [self addChild:scissor];
        
        NSMutableArray *layers = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 5; i++) {
            [layers addObject:[[StageLayer alloc] initWithPage:i]];
        }
        
        stageLayer = [[CCScrollLayer alloc] initWithLayers:layers widthOffset:0];
        
        stageLayer.marginOffset = winSize.width * 0.1;
        stageLayer.minimumTouchLengthToSlide = 0;
        stageLayer.minimumTouchLengthToChangePage = 20;
        stageLayer.delegate = self;
        stageLayer.pagesIndicatorPosition = ccp(stageLayer.pagesIndicatorPosition.x, 30);
        stageLayer.indicatorFile = @"bg/selectstage/bg_chapter_page.png";
        stageLayer.selectIndicatorFile = @"bg/selectstage/bg_chapter_page_selected.png";
        stageLayer.spriteIndicatorDistance = 32;
        [stageLayer addIndicatorLayer];
        [scissor addChild:stageLayer];
    }
    return self;
}

-(void)scrollLayer:(CCScrollLayer *)sender scrollToPageNumber:(int)page {
    [backgroundLayer moveToPage:page];
    CCLOG(@"%d",page);
}

@end
