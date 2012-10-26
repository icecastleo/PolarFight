//
//  CountDownSprite.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CountDownLabel : CCLabelBMFont {
    float time;
}

+(id) labelWithTime:(ccTime)t;
-(id) initWithTime:(ccTime)t;
-(void) resetTime:(ccTime) t;
-(void) start;
@end
