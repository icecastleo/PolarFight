//
//  StageLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/30.
//
//

#import "StageLayer.h"
#import "StageMenuItem.h"

@implementation CCMenu (RowColumnExtend)

+(void)initialize {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"selstagebutton.plist"];
}

-(void)alignItemsWithColumn:(int)column columnPadding:(float)columnPadding row:(int)row rowPadding:(float)rowPadding
{
    if (children_.count == 0) {
        return;
    }
    
    CGRect boundingBox = ((CCMenuItem *)[children_ objectAtIndex:0]).boundingBox;
    
    float width = -columnPadding;
    float height = -rowPadding;
    
    for (int i = 0; i < column; i++) {
        width += boundingBox.size.width + columnPadding;
    }
    
    for (int i = 0; i < row; i++) {
        height += boundingBox.size.height + rowPadding;
    }
    
    float x = -width / 2;
    float y = height / 2;
    
    for (int i = 0; i < children_.count; i++) {
        CCMenuItem *item = [children_ objectAtIndex:i];
        item.position = ccp(x + item.boundingBox.size.width / 2, y - item.boundingBox.size.height / 2);
        
        if ((i + 1) % column == 0) {
            x = -width / 2;
            y -= boundingBox.size.height + rowPadding;
        } else {
            x += boundingBox.size.width + columnPadding;
        }
    }
    
//    float height = -padding;
//    
//	CCMenuItem *item;
//	CCARRAY_FOREACH(children_, item)
//    height += item.contentSize.height * item.scaleY + padding;
//    
//	float y = height / 2.0f;
//    
//	CCARRAY_FOREACH(children_, item) {
//		CGSize itemSize = item.contentSize;
//	    [item setPosition:ccp(0, y - itemSize.height * item.scaleY / 2.0f)];
//	    y -= itemSize.height * item.scaleY + padding;
//	}
}

@end

@implementation StageLayer

-(id)initWithPage:(int)page {
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        CCSprite *background = [CCSprite spriteWithFile:[NSString stringWithFormat:@"bg/selectstage/bg_selectstage_map_%02d.png", page]];
        background.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:background];
        
        CCLayerColor *color = [[CCLayerColor alloc] initWithColor:ccc4(50, 50, 50, 150)];
        [self addChild:color];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 15; i++) {
            CCMenuItem *item = [[StageMenuItem alloc] initWithStagePrefix:page suffix:i];
            [array addObject:item];
        }
        
        CCMenu *menu = [[CCMenu alloc] initWithArray:array];
        menu.position = ccp(winSize.width / 2, winSize.height / 2);
        [menu alignItemsWithColumn:5 columnPadding:0 row:3 rowPadding:0];
        [self addChild:menu];
    }
    return self;
}


@end
