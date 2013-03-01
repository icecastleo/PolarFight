//
//  RangeFarCircle.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/12/13.
//
//

#import "RangeFarCircle.h"

@implementation RangeFarCircle
//NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeFarCircle",@"rangeName",@120,@"effectDistance",@40,@"effectRadius",nil];//FarCircle
//EffectSides:0=effectSideEnemy,1=effectSideAlly,2=effectSideBoth
//effectRadius=攻擊半徑
//effectDistance=攻擊距離


-(void)setSpecialParameter:(NSMutableDictionary*) dict {
    
    int rangeDistance;
    
    NSNumber *distance = [dict valueForKey:@"effectDistance"];
    
    if(distance != nil) {
        NSAssert([distance intValue] >= 0,@"You can not set a radius value below 0.");
        rangeDistance = [distance intValue];
    } else {
        rangeDistance = 0;
    }

    int effectRadius;
    
    NSNumber *radius = [dict valueForKey:@"effectRadius"];
    
    if(radius != nil) {
        NSAssert([radius intValue] > 0,@"You can not set a radius value below 0.");
        effectRadius = [radius intValue];
    } else {
        effectRadius = 50;
    }
    
    rangeWidth = (effectRadius+rangeDistance)*2;
    rangeHeight = (effectRadius+rangeDistance)*2;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, rangeWidth/2+rangeDistance,rangeHeight/2);
    CGPathAddArc(attackRange, NULL, rangeWidth/2+rangeDistance, rangeHeight/2, effectRadius, 0, M_PI*2,NO);
    CGPathCloseSubpath(attackRange);
//    CGPathRetain(attackRange);
}

@end
