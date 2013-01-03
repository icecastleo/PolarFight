//
//  CircleAttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeCircle.h"


@implementation RangeCircle


//NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"rangeSides",@0,@"effectSelfOrNot",@"RangeCircle",@"rangeName",@50,"@radius" nil];//Circle
//EffectSides:0=effectSideEnemy,1=effectSideAlly,2=effectSideBoth
//effectRadius=攻擊半徑:50

-(void)setSpecialParameter:(NSMutableDictionary*)dict {
        
    int effectRadius;
    
    NSNumber *radius = [dict valueForKey:@"effectRadius"];
    
    if(radius != nil) {
        NSAssert([radius intValue] > 0,@"You can not set a radius value below 0.");
        effectRadius = [radius intValue];
    } else {
        effectRadius = 50;
    }
    
    rangeWidth = effectRadius*2;
    rangeHeight = effectRadius*2;
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2,rangeHeight/2);
    CGPathAddArc(attackRange, NULL, rangeWidth/2, effectRadius, effectRadius, 0, M_PI*2,NO);
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}

@end
