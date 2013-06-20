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

@implementation CCActionManager (RepeatForeverAnimateExtend)

//-(void) removeActionByTag:(NSInteger)aTag target:(id)target
//{
//	NSAssert( aTag != kCCActionTagInvalid, @"Invalid tag");
//	NSAssert( target != nil, @"Target should be ! nil");
//    
//	tHashElement *element = NULL;
//	HASH_FIND_INT(targets, &target, element);
//    
//	if( element ) {
//		NSUInteger limit = element->actions->num;
//		for( NSUInteger i = 0; i < limit; i++) {
//			CCAction *a = element->actions->arr[i];
//            
//			if( a.tag == aTag && [a originalTarget]==target) {
//                [a stop];
//				[self removeActionAtIndex:i hashElement:element];
//				break;
//			}
//		}
//        
//	}
//}

@end

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
