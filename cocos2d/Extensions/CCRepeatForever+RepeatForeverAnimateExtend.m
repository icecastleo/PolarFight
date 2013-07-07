//
//  CCAction+CCRepeatForeverExtend.m
//  CastleFight
//
//  Created by 朱 世光 on 13/6/21.
//
//

#import "CCRepeatForever+RepeatForeverAnimateExtend.h"
#import "CCSprite.h"
#import "CCAnimation.h"
#import "CCAction.h"
#import "CCActionInterval.h"
#import "CCActionManager.h"

//@implementation CCActionManager (RepeatForeverAnimateExtend)
//
//@end

@implementation CCRepeatForever (RepeatForeverAnimateExtend)

-(void) stop
{
	[_innerAction stop];
    [super stop];
}

@end

@implementation CCAnimate (RepeatForeverAnimateExtend)

-(void) startWithTarget:(id)aTarget
{
	[super startWithTarget:aTarget];
	CCSprite *sprite = _target;
    
    //	[_origFrame release];
    
	if( !_origFrame && _animation.restoreOriginalFrame )
		_origFrame = [[sprite displayFrame] retain];
	
	_nextFrame = 0;
	_executedLoops = 0;
}

@end
