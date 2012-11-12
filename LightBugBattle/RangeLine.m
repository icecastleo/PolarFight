//
//  RangeLine.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/11/12.
//
//

#import "RangeLine.h"

@implementation RangeLine
-(void)setParameter {
    effectSides = effectSideEnemy;
    effectNums= effectNumsMulti;
    effectSelfOrNot = effectExceptSelf;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, 0,0);
    CGPathAddLineToPoint(attackRange, NULL, 0,rangeHeight/2);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2);
    
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth/2,0);
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}
@end
