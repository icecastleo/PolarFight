//
//  ScrollingNodeOverlay.m
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CCScrollingNodeOverlay.h"

@implementation UIImageView (ForScrollView)

- (void) setAlpha:(float)alpha {
    
    if (self.superview.tag == noDisableVerticalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleLeftMargin) {
            if (self.frame.size.width < 10 && self.frame.size.height > self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.height < sc.contentSize.height) {
                    return;
                }
            }
        }
    }
    
    if (self.superview.tag == noDisableHorizontalScrollTag) {
        if (alpha == 0 && self.autoresizingMask == UIViewAutoresizingFlexibleTopMargin) {
            if (self.frame.size.height < 10 && self.frame.size.height < self.frame.size.width) {
                UIScrollView *sc = (UIScrollView*)self.superview;
                if (sc.frame.size.width < sc.contentSize.width) {
                    return;
                }
            }
        }
    }
    
    [super setAlpha:alpha];
}
@end


@implementation CCScrollingNodeOverlay

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if(!self.dragging) {
        [self.nextResponder touchesBegan:touches withEvent:event];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if(!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    }
}

@end
