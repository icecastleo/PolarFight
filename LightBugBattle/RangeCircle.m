//
//  CircleAttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeCircle.h"


@implementation RangeCircle


//NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeCircle",@"rangeName",@50,"@radius" nil];//Circle
//EffectSides:0=effectSideEnemy,1=effectSideAlly,2=effectSideBoth
//effectRadius=攻擊半徑:50

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
    
    int rangeRadius=50;
    NSNumber *radius = [dict valueForKey:@"effectRadius"];
    if(radius!=nil)
    {
        rangeRadius = [radius intValue]<=0?100:[radius intValue];
       
    }
    rangeWidth= rangeRadius*2;
    rangeHeight=rangeRadius*2;
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2);
    CGPathAddArc(attackRange, NULL, rangeWidth/2, rangeRadius, rangeRadius, 0, M_PI*2,NO);
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}

@end
