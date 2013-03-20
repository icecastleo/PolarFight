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
-(void)setSpecialParameter:(NSMutableDictionary*) dict {
    
    int length;
    NSNumber *l = [dict valueForKey:kRangeKeyLength];
    
    if(l != nil)
    {
        NSAssert([l intValue] > 0, @"You can't set a length value below 0!!");
        length = [l intValue];
    } else {
        length = 500;
    }
    
    int lineWidth;
    NSNumber *w = [dict valueForKey:kRangeKeyWidth];
    
    if(w != nil)
    {
        NSAssert([w intValue] > 0, @"You can't set a width value below 0!!");
        lineWidth = [w intValue];
    } else {
        lineWidth = 20;
    }
    
    length *= kScale;
    lineWidth *= kScale;
    width = length*2;
    height = length*2;
    
    attackRange = CGPathCreateMutable();
    CGPathMoveToPoint(attackRange, NULL, width/2, height/2);
    CGPathAddLineToPoint(attackRange, NULL, width/2, height/2- lineWidth/2);
    CGPathAddLineToPoint(attackRange, NULL, width, height/2 - lineWidth/2);
    CGPathAddLineToPoint(attackRange, NULL, width, height/2 + lineWidth/2);
    CGPathAddLineToPoint(attackRange, NULL, width/2, height/2 + lineWidth/2);
    
    CGPathCloseSubpath(attackRange);
//    CGPathRetain(attackRange);
}


@end
