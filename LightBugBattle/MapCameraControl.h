//
//  MapCameraControl.h
//  MapTest
//
//  Created by Huang Hsing on 12/10/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MapCameraControl : CCNode
{
    CCSprite* map;
    CCCamera* mainCamera;
    CGPoint cameraPosition;
    CGSize mapSize;
    CGSize winSize;
    float heightLimit;
    float widthLimit;
    
    CCSprite* target;
    BOOL isMove;
    CGPoint moveAmount;
}

-(void) setMap:(CCSprite*)theMap mapLayer:(CCNode*)mapLayer;
-(void) moveCameraX:(float)moveX Y:(float)moveY;
-(void) moveCameraToX:(float)moveX Y:(float)moveY;
//-(void) followTarget:(CCSprite*)theTarget;

@end
