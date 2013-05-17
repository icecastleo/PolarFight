//
//  UnitMenuItem.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/14.
//
//

#import "cocos2d.h"
#import "CCMenuItem.h"

@class SummonComponent;

@interface UnitMenuItem : CCMenuItemSprite {
    
}

@property (readonly) CCSprite *mask;
@property (readonly) CCProgressTimer *timer;

-(id)initWithSummonComponent:(SummonComponent *)summon;

@end
