//
//  CCSkeletonAnimation+CheckAnimation.h
//  CastleFight
//
//  Created by  浩翔 on 13/9/16.
//
//

#import "CCSkeletonAnimation.h"

@interface CCSkeletonAnimation (CheckAnimation)

-(BOOL)hasAnimation:(NSString *)name;

-(float)AnimationDuration:(AnimationState *)state;

@end
