//
//  StageLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/30.
//
//

#import "StageLayer.h"
#import "StageMenuItem.h"
#import "FileManager.h"
#import "AchievementManager.h"

@interface CCMenu (RowColumnExtend)

-(void)alignItemsInColumn:(int)column padding:(CGPoint)padding;

@end

@implementation CCMenu (RowColumnExtend)

-(void)alignItemsInColumn:(int)column padding:(CGPoint)padding
{
    if (children_.count == 0) {
        return;
    }
    
    CGRect boundingBox = ((CCMenuItem *)[children_ objectAtIndex:0]).boundingBox;
    
    int row = (children_.count + column - 1) / column;
    
    CGFloat width = boundingBox.size.width * column + padding.x * (column - 1);
    CGFloat height = boundingBox.size.height * row + padding.y * (row - 1);
    
    [self setContentSize:CGSizeMake(width, height)];
    
    CGFloat x = -width / 2;
    CGFloat y = height / 2;
    
    for (int i = 0; i < children_.count; i++) {
        CCMenuItem *item = [children_ objectAtIndex:i];
        item.position = ccp(x + item.boundingBox.size.width / 2, y - item.boundingBox.size.height / 2);
        
        if ((i + 1) % column == 0) {
            x = -width / 2;
            y -= boundingBox.size.height + padding.y;
        } else {
            x += boundingBox.size.width + padding.x;
        }
    }
}

@end

@implementation StageLayer

-(id)initWithPage:(int)page {
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 15; i++) {
            NSString *name = [NSString stringWithFormat:@"%02d_%02d",page,i];
            BOOL unLocked = [[FileManager sharedFileManager].achievementManager getStatusfromAchievement:name];
            int stars;
            if (page != 1) {
                // others acheivement data are not built yet.
                stars = 0;
            }else {
                stars = [[FileManager sharedFileManager].achievementManager getValueFromProperty:[name stringByAppendingFormat:@"_star"]];
            }
            CCMenuItem *item = [[StageMenuItem alloc] initWithStagePrefix:page suffix:i unLocked:unLocked stars:stars];
            [array addObject:item];
        }
        
        CCMenu *menu = [[CCMenu alloc] initWithArray:array];
        menu.position = ccp(winSize.width / 2, winSize.height / 2);
        [menu alignItemsInColumn:5 padding:ccp(15, 0)];
        [self addChild:menu];
    }
    return self;
}

@end
