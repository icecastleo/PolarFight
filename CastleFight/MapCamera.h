//
//  MapCamera.h
//  CastleFight
//
//  Created by 朱 世光 on 13/3/1.
//
//

#import "cocos2d.h"

@class MapLayer;
@class Character;
@interface MapCamera : CCNode {
    MapLayer *layer;
    
    CGPoint center;
    
    float widthMax;
    float heightMax;
}

-(id)initWithMapLayer:(MapLayer *)aLayer;
-(void)moveTo:(CGPoint)position;
-(void)moveBy:(CGPoint)position;
-(void)smoothMoveTo:(CGPoint)position duration:(ccTime)d;
-(void)followCharacter:(Character *)character;
-(void)stopFollow;

@end
