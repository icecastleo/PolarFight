//
//  CountDownSprite.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/25.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "CountDownLabel.h"


@implementation CountDownLabel


+(id) labelWithTime:(ccTime)t {
    return [[[CountDownLabel alloc] initWithTime:t] autorelease];
}

-(id) initWithTime:(ccTime)t {
    if(self = [super initWithString:[NSString stringWithFormat:@"%.2f",t] fntFile:@"TestFont.fnt"]) {
        time = t;
//        accumulative = 0.0;
    }
    return self;
}


-(void) resetTime:(ccTime) t {
    [self unscheduleUpdate];
    
    time = t;
//    accumulative = 0.0;
    
    [self setString:[NSString stringWithFormat:@"%.2f",time]];
    
    self.visible = YES;
}

-(void) start {
    [self scheduleUpdate];
}

-(void) update:(ccTime) delta {
//    accumulative += delta;
    
//    if(accumulative >= 1) {
//        accumulative--;
//        time--;
    time -= delta;
    
    [self setString:[NSString stringWithFormat:@"%.2f",time]];
//    }
}

@end
