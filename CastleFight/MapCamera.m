//
//  MapCamera.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/1.
//
//

#import "MapCamera.h"
#import "MapLayer.h"

@implementation MapCamera

-(id)initWithMapLayer:(MapLayer *)aLayer {
    if (self = [super init]) {
        layer = aLayer;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        center = ccp(winSize.width / 2, winSize.height / 2);
        
        // Prevent boundary < winSize
        widthMax = MAX(0, layer.boundaryX - winSize.width);
        heightMax = MAX(0, layer.boundaryY - winSize.height);
        
        move = NO;
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

@end
