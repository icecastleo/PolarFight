//
//  RangeLine.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/11/12.
//
//

#import "RangeLine.h"

@implementation RangeLine


  //NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeLine",@"rangeName",@700,@"effectDistance",@40,@"effectWidth",nil];//Line
//EffectSides:0=effectSideEnemy,1=effectSideAlly,2=effectSideBoth
//effectDistance=攻擊長度
//effectWidth=攻擊寬度
-(void)setParameter:(NSMutableDictionary*) dict {
    
    NSNumber *sides = [dict valueForKey:@"effectSides"];
    if(sides!=nil)
    {
        effectSides= [sides intValue]>3?0:[sides intValue];
    }else{
        effectSides = effectSideEnemy;
    }
    NSNumber *selfOrNot = [dict valueForKey:@"effectSelfOrNot"];
    if(selfOrNot!=nil)
    {
        effectSelfOrNot= [selfOrNot intValue]>3?0:[selfOrNot intValue];
    }else{
        effectSelfOrNot = effectExceptSelf;
    }
    
    
    NSNumber *distance = [dict valueForKey:@"effectDistance"];
    if(distance!=nil)
    {
        int rangeRadius = [distance intValue]<=0?700:[distance intValue];
        rangeWidth= rangeRadius;
        rangeHeight=rangeRadius;
    }else{
        rangeWidth= 700;
        rangeHeight=700;
    }
    int effectWidth=40;
    NSNumber *width = [dict valueForKey:@"effectWidth"];
    if(width!=nil)
    {
        effectWidth = [width intValue]<=0?20:[width intValue];
      
    }
    
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2-effectWidth/2);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth,rangeHeight/2-effectWidth/2);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth,rangeHeight/2+effectWidth/2);
    CGPathAddLineToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2+effectWidth/2);
    
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}


@end
