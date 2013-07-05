//
//  FanShape.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RangeFanShape.h"


@implementation RangeFanShape

//NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],kRangeKeySide,kRangeTypeFanShape,kRangeKeyType,@80,kRangeKeyRadius,@(M_PI/2),kRangeKeyAngle,@1,kRangeKeyTargetLimit,nil];

//kRangeKeyAngle = 攻擊角度

-(void)setSpecialParameter:(NSMutableDictionary*) dict {
    
    int radius;
    NSNumber *r = [dict valueForKey:kRangeKeyRadius];
    
    if(r != nil) {
        NSAssert([r intValue] > 0, @"You can't set a radius value below 0!!");
        radius = [r intValue];
    } else {
        radius = 50;
    }
    
    width = radius*2;
    height = radius*2;
    
    double angle;
    
    NSNumber *a = [dict valueForKey:kRangeKeyAngle];
    
    if(a != nil) {
        NSAssert([a doubleValue] > 0, @"You can't set an angle value below 0!!");
        NSAssert(M_PI * 2 >= [a doubleValue], @"You can't set an angle value bigger than M_PI * 2!!");
        angle = [a doubleValue];
    } else {
        angle = M_PI/2;
    }
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, radius, radius);
    CGPathAddArc(attackRange, NULL, radius, radius, radius, -M_PI/2 - angle/2, -M_PI/2 + angle/2, NO);
    CGPathCloseSubpath(attackRange);
//    CGPathRetain(attackRange);
}

@end
