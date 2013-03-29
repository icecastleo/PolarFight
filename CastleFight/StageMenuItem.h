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
}

-(id)initWithStagePrefix:(int)aPrefix suffix:(int)aSuffix;

@end
