//
//  MapCameraControl.h
//  MapTest
//
//  Created by Huang Hsing on 12/10/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class MapLayer;
@interface MapCameraControl : CCNode
{
    CCCamera* camera;

    float cameraZ;
    
    float heightLimit;
    float widthLimit;
    
    id target;
    SEL selector;
    
    float moveX;
    float moveY;
    bool move;
    
    int moveCountDown;
    CGPoint delta;
    CGPoint acceleration;
}
@property (readonly) CGPoint cameraPosition;

-(id)initWithMapLayer:(MapLayer *)layer mapSprite:(CCSprite *)sprite;
-(void)moveCameraX:(float)x Y:(float)y;
-(void)moveCameraToX:(float)x Y:(float)y;
-(void)smoothMoveCameraToX:(float)x Y:(float)y;
-(void)smoothMoveCameraToX:(float)x Y:(float)y delegate:(id)aTarget selector:(SEL)aSelector;

-(void)setDefaultZ;
-(void)moveCameraZ:(float)zValue;

@end
