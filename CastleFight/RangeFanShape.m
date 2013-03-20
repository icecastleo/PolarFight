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
    
    int radius;
    NSNumber *r = [dict valueForKey:kRangeKeyRadius];
    
    if(r != nil) {
        NSAssert([r intValue] > 0, @"You can't set a radius value below 0!!");
        radius = [r intValue];
    } else {
        radius = 50;
    }
    
    radius *= kScale;
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
    CGPathMoveToPoint(attackRange, NULL, width/2, height/2);
    CGPathAddArc(attackRange, NULL, width/2, height/2, radius, angle/(-2), angle/2, NO);
    CGPathCloseSubpath(attackRange);
//    CGPathRetain(attackRange);
}

@end
