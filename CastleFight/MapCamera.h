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
-(void)moveCameraX:(float)x Y:(float)y;
-(void)moveCameraToX:(float)x Y:(float)y;
-(void)smoothMoveCameraToX:(float)x Y:(float)y;
-(void)smoothMoveCameraToX:(float)x Y:(float)y delegate:(id)aTarget selector:(SEL)aSelector;

@end
