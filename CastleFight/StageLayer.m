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

@implementation StageLayer

-(id)initWithPage:(int)page {
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i = 1; i <= 15; i++) {
            NSString *name = [NSString stringWithFormat:@"%02d_%02d",page,i];
            BOOL unlocked = [[FileManager sharedFileManager].achievementManager getStatusfromAchievement:name];
            
            // FIXME: Other star data are not built yet.
            int stars;
            if (page != 1) {
                stars = 0;
            } else {
                stars = [[FileManager sharedFileManager].achievementManager getValueFromProperty:[name stringByAppendingFormat:@"_star"]];
            }
            
            CCMenuItem *item = [[StageMenuItem alloc] initWithStagePrefix:page suffix:i unlocked:unlocked stars:stars];
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
