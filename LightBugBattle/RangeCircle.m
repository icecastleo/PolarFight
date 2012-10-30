//
//  CircleAttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeCircle.h"


@implementation RangeCircle

-(void)setParameter {
    effectSides = effectSideEnemy;
    effectNums= effectNumsMulti;
    effectSelfOrNot = effectExceptSelf;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2);
    CGPathAddArc(attackRange, NULL, rangeWidth/2, rangeHeight/2, 50, 0, M_PI*2,NO);
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}
@end
