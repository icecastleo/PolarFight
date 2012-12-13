//
//  RangeFarCircle.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/12/13.
//
//

#import "RangeFarCircle.h"

@implementation RangeFarCircle
-(void)setParameter {
    rangeWidth=400;
    rangeHeight=400;
    effectSides = effectSideEnemy;
    effectNums= effectNumsMulti;
    effectSelfOrNot = effectExceptSelf;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2+120,rangeHeight/2);
    CGPathAddArc(attackRange, NULL, rangeWidth/2+120, rangeHeight/2, 40, 0, M_PI*2,NO);
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}
@end
