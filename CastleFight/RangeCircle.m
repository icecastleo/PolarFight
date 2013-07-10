//
//  CircleAttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeCircle.h"


@implementation RangeCircle


//NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeCircle,kRangeKeyType,@80,kRangeKeyRadius,@80,kRangeKeyDistance,@1,kRangeKeyTargetLimit,nil];

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
    
    width = radius*2;
    height = (distance + radius)*2;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, radius, radius);
    CGPathAddArc(attackRange, NULL, radius, radius, radius, 0, M_PI*2, NO);
    CGPathCloseSubpath(attackRange);
//    CGPathRetain(attackRange);
}

@end
