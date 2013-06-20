//
//  DrawMyTouch.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/17.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "DrawPath.h"


@implementation DrawPath

-(void)draw
{
//    glEnable(GL_LINE_SMOOTH);
    
    // it needs start and end points at least.
    if (self.path.count < 2) {
        return;
    }
    
    for(int i = 0; i < [self.path count]; i+=2)
    {
        start = [(NSValue *)[self.path objectAtIndex:i] CGPointValue];
        end = [(NSValue *)[self.path objectAtIndex:i+1] CGPointValue];
        
        ccDrawLine(start, end);
    }
    
    //TODO: radius depends on range's radius
    ccDrawCircle(end, 50, 360, 30, NO);
}

@end
