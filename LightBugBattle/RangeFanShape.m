//
//  FanShape.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeFanShape.h"


@implementation RangeFanShape


// NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@1,@"effectSides",@0,@"effectSelfOrNot",@"RangeFanShape",@"rangeName",@200,@"effectRadius",@(M_PI/2),@"effectAngle",nil];    //FanShape
//EffectSides:0=effectSideEnemy,1=effectSideAlly,2=effectSideBoth
//effectRadius=攻擊半徑
//effectAngle=攻擊角度

-(void)setSpecialParameter:(NSMutableDictionary*) dict {
    
    
    int rangeRadius=50;
    NSNumber *radius = [dict valueForKey:@"effectRadius"];
    if(radius!=nil)
    {
        rangeRadius = [radius intValue]<=0?50:[radius intValue];
       
    }
    rangeWidth= rangeRadius*2;
    rangeHeight=rangeRadius*2;
    double rangeAngle= M_PI/2;
    
    NSNumber *angle = [dict valueForKey:@"effectAngle"];
    if(angle!=nil)
    {
        rangeAngle = ([angle doubleValue]<M_PI*-2||[angle doubleValue]>M_PI*2)? M_PI/2:[angle doubleValue];
       
    }
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2);
    CGPathAddArc(attackRange, NULL, rangeWidth/2, rangeHeight/2, rangeRadius, rangeAngle/(-2), rangeAngle/2,NO);
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}

@end
