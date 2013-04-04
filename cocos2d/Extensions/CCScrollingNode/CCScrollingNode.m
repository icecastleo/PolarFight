//
//  ScrollingNode.m
//  Cocos2dScrolling
//
//  Created by Tony Ngo on 11/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CCScrollingNode.h"
#import "CCScrollingNodeOverlay.h"

@implementation CCScrollingNode

@synthesize scrollView=scrollView_;

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
        scrollView_ = [[[CCScrollingNodeOverlay alloc] initWithFrame:CGRectMake(_rect.origin.x, uiY, _rect.size.width, _rect.size.height)] retain];
        self.position = ccp(0, 0);
        scrollView_.tag = noDisableVerticalScrollTag;
        scrollView_.delegate = self;
        scrollView_.showsVerticalScrollIndicator = YES;
        scrollView_.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        scrollView_.bounces = NO;

    }
    return self;
}

-(void)setPosition:(CGPoint)position {
    [super setPosition:ccp(position.x + _rect.origin.x, position.y - uiY)];
}

- (void)dealloc
{
    [scrollView_ release];
    [super dealloc];
}

@end
