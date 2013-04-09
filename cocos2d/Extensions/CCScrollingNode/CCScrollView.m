//
//  ScrollingNodeOverlay.m
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CCScrollView.h"

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

@interface TouchTimerObject : NSObject  {
   
}

@property (readonly) NSSet *touches;
@property (readonly) UIEvent *event;

-(id)initWithTouches:(NSSet *)touches event:(UIEvent *)event;

@end

@implementation TouchTimerObject

-(id)initWithTouches:(NSSet *)t event:(UIEvent *)e {
    if (self = [super init]) {
        _touches = [t retain];
        _event = [e retain];
    }
    return self;
}

-(void)dealloc {
    [_touches release];
    [_event release];
    [super dealloc];
}

@end

@implementation CCScrollView

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.nextResponder touchesBegan:touches withEvent:event];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    [self.nextResponder touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    [self.nextResponder touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
//    [self.nextResponder touchesEnded:touches withEvent:event];
    
    TouchTimerObject *object = [[TouchTimerObject alloc] initWithTouches:touches event:event];
    
    [NSTimer scheduledTimerWithTimeInterval:0.075f target:self selector:@selector(timerFireMethod:) userInfo:object repeats:NO];
}

-(void)timerFireMethod:(NSTimer *)timer {
    TouchTimerObject *object = timer.userInfo;
    [self.nextResponder touchesEnded:object.touches withEvent:object.event];
}

@end
