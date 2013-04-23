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
    
    int radius;
    NSNumber *r = [dict valueForKey:kRangeKeyRadius];
    
    if(r != nil) {
        NSAssert([r intValue] > 0, @"You can not set a radius value below 0!!");
        radius = [r intValue];
    } else {
        radius = 50;
    }
    
    int distance;
    NSNumber *d = [dict valueForKey:kRangeKeyDistance];
    
    if(d != nil) {
        NSAssert([d intValue] > 0, @"You can not set a distance value below 0!!");
        distance = [d intValue];
    } else {
        distance = 0;
    }
    
    radius *= kScale;
    distance *= kScale;
    width =  distance + radius*2;
    height = radius*2;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, distance + width/2, height/2);
    CGPathAddArc(attackRange, NULL, distance + width/2, height/2, radius, 0, M_PI*2, NO);
    CGPathCloseSubpath(attackRange);
//    CGPathRetain(attackRange);
}

@end
