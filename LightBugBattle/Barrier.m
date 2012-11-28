//
//  Barrier.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Barrier.h"


@implementation Barrier
@synthesize center, radius;

-(void) setShapeRoundRadius:(float)r center:(CGPoint)point
{
    radius = r;
    center = ccpAdd( [self position], point );
}

@end
