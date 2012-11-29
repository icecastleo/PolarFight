//
//  FanShape.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeFanShape.h"


@implementation RangeFanShape

-(void)setParameter {
    effectSides = effectSideEnemy;
    effectNums= effectNumsMulti;
    effectSelfOrNot = effectExceptSelf;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2);
    CGPathAddArc(attackRange, NULL, rangeWidth/2, rangeHeight/2, 50, M_PI/4*7, M_PI/4*1,NO);
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}


@end
