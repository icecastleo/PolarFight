//
//  EffectTimeStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/18.
//
//

#import "TimeStatusEffect.h"

@implementation TimeStatusEffect

+(id)statusWithType:(TimeStatusType)statusType withTime:(int)t {
    return [[self alloc] initWithType:statusType withTime:t];
}

-(id)initWithType:(TimeStatusType)statusType withTime:(int)t {
    if(self = [super init]) {
        type = statusType;
        time = t;
    }
    return self;
}

-(void)doEffect:(Character *)character {
    [character addTimeStatus:type withTime:time];
}

@end
