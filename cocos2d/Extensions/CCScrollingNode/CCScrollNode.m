//
//  ScrollingNode.m
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCScrollNode.h"

#ifdef __CC_PLATFORM_IOS

@interface CCNode (CCScrollOverride)

@end

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

@implementation CCNode (CCScrollOverride)

- (CGPoint)convertTouchToNodeSpace:(UITouch *)touch
{
	CGPoint point = [touch locationInView: [CCDirector sharedDirector].view];
	point = [[CCDirector sharedDirector] convertToGL: point];
	return [self convertToNodeSpace:point];
}

- (CGPoint)convertTouchToNodeSpaceAR:(UITouch *)touch
{
	CGPoint point = [touch locationInView: [CCDirector sharedDirector].view];
	point = [[CCDirector sharedDirector] convertToGL: point];
	return [self convertToNodeSpaceAR:point];
}

@end

@implementation CCMenu (CCScrollOverride)

-(CCMenuItem *) itemForTouch: (UITouch *) touch
{
	CGPoint touchLocation = [touch locationInView: [CCDirector sharedDirector].view];
	touchLocation = [[CCDirector sharedDirector] convertToGL: touchLocation];
    
	CCMenuItem* item;
	CCARRAY_FOREACH(children_, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
            
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item rect];
			r.origin = CGPointZero;
            
			if( CGRectContainsPoint( r, local ) )
				return item;
		}
	}
	return nil;
}

@end

#pragma clang diagnostic pop

#endif // __CC_PLATFORM_IOS

@implementation CCScrollNode

@synthesize scrollView = scrollView_;

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGPoint contentOffset = [scrollView contentOffset];
    [self setPosition:contentOffset];
}

- (void)onEnter
{
    [super onEnter];
    [[CCDirector sharedDirector].view addSubview:scrollView_];
    [scrollView_ flashScrollIndicators];
}

- (void)onExit
{
    [super onExit];
    [scrollView_ removeFromSuperview];
}

#pragma mark - Initialization

- (id)initWithRect:(CGRect)aRect
{
    if(self = [super init]) {
        _rect = aRect;
        uiY = [CCDirector sharedDirector].winSize.height - _rect.size.height - _rect.origin.y;
        scrollView_ = [[[CCScrollView alloc] initWithFrame:CGRectMake(_rect.origin.x, uiY, _rect.size.width, _rect.size.height)] retain];
        self.position = ccp(0, 0);
        scrollView_.delegate = self;
    }
    return self;
}

-(void)setPosition:(CGPoint)position {
    if (_adjustPosition) {
        [super setPosition:ccp(-position.x + _rect.origin.x, position.y - uiY)];
    } else {
        [super setPosition:ccp(-position.x, position.y)];
    }
}

-(void)setAdjustPosition:(BOOL)adjustPosition {
    _adjustPosition = adjustPosition;
    
    if (adjustPosition) {
        position_ = ccp(position_.x + _rect.origin.x, position_.y - uiY);
    } else {
        position_ = ccp(position_.x - _rect.origin.x, position_.y + uiY);
    }
}

- (void)dealloc
{
    [scrollView_ release];
    [super dealloc];
}

@end
