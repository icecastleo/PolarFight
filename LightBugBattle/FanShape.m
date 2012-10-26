//
//  FanShape.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "FanShape.h"


@implementation FanShape

-(void)setParameter {
    effectSides = effectSideEnemy;
    effectNums= effectNumsMulti;
    effectSelfOrNot = effectExceptSelf;
    
    attackPointArray = [NSMutableArray arrayWithObjects:
    [NSValue valueWithCGPoint:ccp(0, 32)],
    [NSValue valueWithCGPoint:ccp(32, 32)],
    [NSValue valueWithCGPoint:ccp(32, 64)],
    [NSValue valueWithCGPoint:ccp(0, 64)],nil];
    [self setPath];
     [attackPointArray retain];
}

- (void) dealloc
{
    [attackPointArray release];
	[super dealloc];
}
@end
