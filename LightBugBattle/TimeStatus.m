//
//  TimeStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "TimeStatus.h"

@implementation TimeStatus
@synthesize time;

-(id)initWithTime:(int)t {
    if(self = [super init]) {
        time = t;
        [self addEffect];
    }
    return self;
}

-(void)addTime:(int)t {
    time += t;
}

-(void)minusTime:(int)t {
    time -= t;
    
    if (time <= 0) {
        [self removeEffect];
    }
}

-(void)update {
    [self minusTime:1];
}

@end
