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
#import "CCScrollLayerAdvance.h"

@implementation StageScrollLayer

-(id)init {
    //TODO: init by user stage info
    
    if (self = [super init]) {
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"selstagebutton.plist"];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"etc.plist"];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
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
        
        NSMutableArray *layers = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 5; i++) {
            [layers addObject:[[StageLayer alloc] initWithPage:i]];
        }
        
        CCScrollLayerAdvance *layer = [[CCScrollLayerAdvance alloc] initWithRect:CGRectMake(0, 0, winSize.width, winSize.height - 50) layers:layers];
        [self addChild:layer];
        
    }
    return self;
}

-(void)scrollLayer:(CCScrollLayer *)sender scrollToPageNumber:(int)page {
    [backgroundLayer moveToPage:page];
}

@end
