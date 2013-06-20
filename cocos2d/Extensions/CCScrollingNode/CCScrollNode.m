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
	CCARRAY_FOREACH(_children, item){
		// ignore invisible and disabled items: issue #779, #866
		if ( [item visible] && [item isEnabled] ) {
            
			CGPoint local = [item convertToNodeSpace:touchLocation];
			CGRect r = [item activeArea];
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
    [scrollView_ removeFromSuperview];
    [super onExit];
}

#pragma mark - Initialization

- (id)initWithRect:(CGRect)aRect
{
    if(self = [super init]) {
        _rect = aRect;
        uiY = [CCDirector sharedDirector].winSize.height - _rect.size.height - _rect.origin.y;
        scrollView_ = [[[CCScrollView alloc] initWithFrame:CGRectMake(_rect.origin.x, uiY, _rect.size.width, _rect.size.height)] retain];
        scrollView_.delegate = self;
        
        self.position = ccp(0, 0);
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
        _position = ccp(_position.x + _rect.origin.x, _position.y - uiY);
    } else {
        _position = ccp(_position.x - _rect.origin.x, _position.y + uiY);
    }
}

- (void)dealloc
{
    [scrollView_ release];
    [super dealloc];
}

@end
