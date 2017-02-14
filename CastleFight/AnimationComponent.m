//
//  AnimationComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "AnimationComponent.h"

@implementation AnimationComponent

+(NSString *)name {
    static NSString *name = @"AnimationComponent";
    return name;
}

-(id)initWithAnimations:(NSMutableDictionary *)animations {
    if (self = [super init]) {
        _animations = animations;
        _state = kAnimationStateNone;
    }
    return self;
}

@end
