//
//  MapCamera.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/1.
//
//

#import "MapCamera.h"
#import "MapLayer.h"

@interface CCSmoothFollow : CCFollow

@end

const static int kFollowLimit = 50;

@implementation CCSmoothFollow

-(void) step:(ccTime) dt
{
	if(_boundarySet)
	{
		// whole map fits inside a single screen, no need to modify the position - unless map boundaries are increased
		if(_boundaryFullyCovered)
			return;
        
		CGPoint tempPos = ccpSub(_halfScreenSize, _followedNode.position);
        
        CCNode *target = _target;
        
        tempPos = ccp(clampf(tempPos.x, target.position.x - kFollowLimit, target.position.x + kFollowLimit), clampf(tempPos.y, target.position.y - kFollowLimit, target.position.y + kFollowLimit));
  
        [(CCNode *)_target setPosition:ccp(clampf(tempPos.x,_leftBoundary,_rightBoundary), clampf(tempPos.y,_bottomBoundary,_topBoundary))];
	}
	else
		[(CCNode *)_target setPosition:ccpSub( _halfScreenSize, _followedNode.position )];
}

@end

@implementation MapCamera

-(id)initWithMapLayer:(MapLayer *)aLayer {
    if (self = [super init]) {
        layer = aLayer;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        center = ccp(winSize.width / 2, winSize.height / 2);
        
        // Prevent boundary < winSize
        widthMax = MAX(0, layer.boundaryX - winSize.width);
        heightMax = MAX(0, layer.boundaryY - winSize.height);
    }
    return self;
}

-(CGPoint)convertPosition:(CGPoint)position {
    return ccpAdd(ccpMult(position, -1), center);
}

-(void)moveBy:(CGPoint)position {
    [self setMapPosition:ccpSub(layer.position, position)];
}

-(void)moveTo:(CGPoint)position {
    [self setMapPosition:[self convertPosition:position]];
}

-(void)setMapPosition:(CGPoint)position {
//    NSAssert(!move, @"You can't move camera during a smooth move!");
    if (layer.numberOfRunningActions != 0) {
//    CCLOG(@"You can't move camera during a smooth move!");
        return;
    }
    layer.position = ccp(MAX(MIN(0, position.x), -widthMax),MAX(MIN(0, position.y), -heightMax));
}

-(void)smoothMoveTo:(CGPoint)position duration:(ccTime)d {
    if (layer.numberOfRunningActions != 0) {
        [layer stopAllActions];
    }
    
    [layer runAction:[CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:d position:[self convertPosition:position]] rate:5.0f]];
}

//-(void)followCharacter:(Character *)character {
//    if (layer.numberOfRunningActions != 0) {
//        [layer stopAllActions];
//    }
//    
//    [layer runAction:[CCSmoothFollow actionWithTarget:character.sprite worldBoundary:CGRectMake(0, 0, layer.boundaryX, [CCDirector sharedDirector].winSize.height)]];
//}

-(void)stopFollow {
    [layer stopAllActions];
}

@end
