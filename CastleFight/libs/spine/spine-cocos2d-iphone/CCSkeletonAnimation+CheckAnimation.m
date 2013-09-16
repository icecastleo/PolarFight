//
//  CCSkeletonAnimation+CheckAnimation.m
//  CastleFight
//
//  Created by  浩翔 on 13/9/16.
//
//

#import "CCSkeletonAnimation+CheckAnimation.h"

@implementation CCSkeletonAnimation (CheckAnimation)

-(BOOL)hasAnimation:(NSString *)name {    
    AnimationState* state = [[_states objectAtIndex:0] pointerValue];
    if (SkeletonData_findAnimation(state->data->skeletonData, [name UTF8String])) return YES;
    return NO;
}

-(float)AnimationDuration:(AnimationState *)state {
    float duration = 0;
    if (state->animation)
        duration = state->animation->duration;
    return duration;
}


@end
