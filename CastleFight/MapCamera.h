//
//  MapCamera.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/1.
//
//

#import "cocos2d.h"

@class MapLayer;
@interface MapCamera : CCNode {
    MapLayer *layer;
    
    CGPoint center;
    
    float widthMax;
    float heightMax;
    
    id target;
    SEL selector;
    
    float moveX;
    float moveY;
    bool move;
    
    int moveCountDown;
    CGPoint delta;
    CGPoint acceleration;
}

-(id)initWithMapLayer:(MapLayer *)aLayer;
-(void)moveTo:(CGPoint)position;
-(void)moveBy:(CGPoint)position;
-(void)smoothMoveTo:(CGPoint)position duration:(ccTime)d;


@end
