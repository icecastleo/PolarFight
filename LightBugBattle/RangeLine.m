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
    rangeWidth=700;
    rangeHeight=700;
    effectSides = effectSideEnemy;
    effectNums= effectNumsMulti;
    effectSelfOrNot = effectExceptSelf;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth/2+10,rangeHeight/2-20);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth,rangeHeight/2-20);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth,rangeHeight/2+20);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth/2+10,rangeHeight/2+20);
  
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}
@end
