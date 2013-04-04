//
//  StageMenuItem.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/30.
//
//

#import "cocos2d.h"

@interface StageMenuItem : CCMenuItemImage {
    int prefix;
    int suffix;
    BOOL unLocked;
}

-(id)initWithStagePrefix:(int)aPrefix suffix:(int)aSuffix unLocked:(BOOL)unLocked stars:(int)stars;

@end
