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
        
        _verticalScissor = YES;
        _horizontalScissor = YES;
        
        // You will touch unseen layer without it!
        [self setTouchEnabled:YES];
    }
    return self;
}

-(void)registerWithTouchDispatcher {
	CCDirector *director = [CCDirector sharedDirector];
	[[director touchDispatcher] addTargetedDelegate:self priority:kCCScissorLayerTouchPriority swallowsTouches:YES];
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
    
    if (_horizontalScissor && _verticalScissor) {
        glScissor((GLint) pixelRect.origin.x, (GLint) pixelRect.origin.y,
                  (GLint) pixelRect.size.width, (GLint) pixelRect.size.height);
    } else if (_horizontalScissor) {
        CGSize pixelWinSize =  CC_SIZE_POINTS_TO_PIXELS([CCDirector sharedDirector].winSize);
        
        glScissor((GLint) pixelRect.origin.x, (GLint) pixelRect.origin.y,
                  (GLint) pixelRect.size.width, (GLint) pixelWinSize.height);
    } else if (_verticalScissor) {
        CGSize pixelWinSize =  CC_SIZE_POINTS_TO_PIXELS([CCDirector sharedDirector].winSize);
        
        glScissor((GLint) pixelRect.origin.x, (GLint) pixelRect.origin.y,
                  (GLint) pixelWinSize.width, (GLint) pixelRect.size.height);
    }
}

-(void)postVisit {
    glDisable(GL_SCISSOR_TEST);
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint point = [self convertTouchToNodeSpace:touch];
    point = [self.parent convertToWorldSpace:point];
    
    if (_horizontalScissor && _verticalScissor) {
        if (CGRectContainsPoint(rect, point)) {
            return NO;
        } else {
            return YES;
        }
    } else if (_horizontalScissor) {
        if  (point.x > rect.origin.x + rect.size.width || point.x < rect.origin.x) {
            return YES;
        } else {
            return NO;
        }
    } else if (_verticalScissor) {
        if  (point.y > rect.origin.y + rect.size.height || point.y < rect.origin.y) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

@end
