//
//  CCScissorLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/3.
//
//

#import "CCScissorLayer.h"

@implementation CCScissorLayer

-(id)initWithRect:(CGRect)aRect {
    if (self = [super init]) {
        rect = CC_RECT_POINTS_TO_PIXELS(aRect);
    }
    return self;
}

-(void)visit {
    [self preVisit];
    [super visit];
    [self postVisit];
}

-(void)preVisit {
    if (!self.visible)
        return;
    
    glEnable(GL_SCISSOR_TEST);
    
    glScissor((GLint) rect.origin.x, (GLint)rect.origin.y,
              (GLint) rect.size.width, (GLint) rect.size.height);
}

-(void)postVisit {
    glDisable(GL_SCISSOR_TEST);
}

@end
