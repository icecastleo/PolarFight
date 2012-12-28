//
//  MapCameraControl.m
//  MapTest
//
//  Created by Huang Hsing on 12/10/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapCameraControl.h"


@implementation MapCameraControl

-(id) init
{
    if((self=[super init]))
    {
        target = NULL;
        isMove = NO;
        moveAmount = ccp(0,0);
        cameraPosition = ccp(0,0);
        winSize = [CCDirector sharedDirector].winSize;
        [self moveCameraToX:0 Y:0];
    }
    return self;
}

-(void) setMap:(CCSprite*)theMap mapLayer:(CCNode*)mapLayer
{
    map = theMap;
    mainCamera = mapLayer.camera;
    mapSize = theMap.boundingBox.size;
    heightLimit = (mapSize.height - winSize.height)/2;
    widthLimit = (mapSize.width - winSize.width)/2;
}

-(void) moveCameraX:(float)moveX Y:(float)moveY {
    [self moveCameraToX:cameraPosition.x + moveX Y:cameraPosition.y + moveY];
}
 
//-(void) followTarget:(CCSprite*)theTarget
//{
//    if( theTarget == NULL )
//    {
//        [self unschedule:@selector(followUpdate:)];
//        return ;
//    }
//    target = theTarget;
//    [self schedule:@selector(followUpdate:)];
//}

-(void) moveCameraToX:(float)moveX Y:(float)moveY
{
    cameraPosition.y = MIN(heightLimit, MAX(-1 * heightLimit, moveY));
    cameraPosition.x = MIN(widthLimit, MAX(-1 * widthLimit, moveX));
    
    [mainCamera setCenterX:cameraPosition.x centerY:cameraPosition.y centerZ:0];
    [mainCamera setEyeX:cameraPosition.x eyeY:cameraPosition.y eyeZ:415];
}

//-(void) followUpdate:(ccTime) dt
//{
//    [self moveCameraToX:target.position.x Y:target.position.y];
//}

@end

