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
        rect = aRect;
        pixelRect = CC_RECT_POINTS_TO_PIXELS(rect);
    }
    return self;
}

-(void)registerWithTouchDispatcher {
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:kCCMenuHandlerPriority+1 swallowsTouches:YES];
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
    
    glScissor((GLint) pixelRect.origin.x, (GLint) pixelRect.origin.y,
              (GLint) pixelRect.size.width, (GLint) pixelRect.size.height);
}

-(void)postVisit {
    glDisable(GL_SCISSOR_TEST);
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [self convertTouchToNodeSpace:touch];
    
    if (CGRectContainsPoint(rect, point)) {
        return NO;
    }
    
    return YES;
}

@end
