//
//  MapCameraControl.m
//  MapTest
//
//  Created by Huang Hsing on 12/10/24.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapCameraControl.h"
#import "MapLayer.h"

const static int kMoveTotalFps = kGameSettingFps;
const static int kMoveSlowFPS = kGameSettingFps / 4;
const static int kMoveSlowRatio = 30;

@implementation MapCameraControl

-(id)initWithMapLayer:(MapLayer *)layer mapSprite:(CCSprite *)sprite {
    if((self=[super init])) {
        CGSize mapSize = sprite.boundingBox.size;
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        heightLimit = (mapSize.height - winSize.height) / 2;
        widthLimit = (mapSize.width - winSize.width) / 2;
        
        camera = layer.camera;
        
        _cameraPosition = ccp(0, 0);
        
        cameraZ = [CCCamera getZEye];
        
        [self moveCameraToX:0 Y:0];
        
        move = false;
    }
    return self;
}

-(void)moveCameraX:(float)x Y:(float)y {
    [self moveCameraToX:_cameraPosition.x + x Y:_cameraPosition.y + y];
}

-(void)moveCameraToX:(float)x Y:(float)y
{
//    NSAssert(!move, @"You can't move camera during a smooth move!");
    if (move) {
//        CCLOG(@"You can't move camera during a smooth move!");
        return;
    }
    
    _cameraPosition.x = MIN(widthLimit, MAX(-1 * widthLimit, x));
    _cameraPosition.y = MIN(heightLimit, MAX(-1 * heightLimit, y));
    
    [camera setCenterX:_cameraPosition.x centerY:_cameraPosition.y centerZ:0];
    [camera setEyeX:_cameraPosition.x eyeY:_cameraPosition.y eyeZ:cameraZ];
}

// TODO: Add callback
-(void)smoothMoveCameraToX:(float)x Y:(float)y {
    if (move) {
        [self unscheduleMove];
    }
    move = YES;
    
    float targetX = MIN(widthLimit, MAX(-1 * widthLimit, x));
    float targetY = MIN(heightLimit, MAX(-1 * heightLimit, y));
    
    moveX = targetX - _cameraPosition.x;
    moveY = targetY - _cameraPosition.y;
    
    moveLength = ccpLength(ccp(moveX, moveY));
    
    delta = ccpMult(ccpForAngle(atan2f(moveY, moveX)), moveLength * (kMoveSlowRatio - 1) / kMoveSlowRatio / (kMoveTotalFps - kMoveSlowFPS));
    
    moveCountDown = kMoveTotalFps;
    
    [self scheduleUpdate];
}

-(void)update:(ccTime)deltaTime {
    if (moveX == 0 && moveY == 0) {
        [self unscheduleMove];
        return;
    }
    
    moveCountDown --;
    
    if (moveCountDown == kMoveSlowFPS) {
        delta = ccpMult(ccpForAngle(atan2f(moveY, moveX)), moveLength * 1 / kMoveSlowRatio / kMoveSlowFPS);
    }
    
    float updateX;
    float updateY;
    
    if (moveX > 0) {
        updateX = MIN(moveX, delta.x);
    } else {
        updateX = MAX(moveX, delta.x);
    }
    moveX -= updateX;
    
    if (moveY > 0) {
        updateY = MIN(moveY, delta.y);
    } else {
        updateY = MAX(moveY, delta.y);
    }
    moveY -= updateY;
    
    _cameraPosition.x += updateX;
    _cameraPosition.y += updateY;
    
    [camera setCenterX:_cameraPosition.x centerY:_cameraPosition.y centerZ:0];
    [camera setEyeX:_cameraPosition.x eyeY:_cameraPosition.y eyeZ:cameraZ];
}

-(void)unscheduleMove {
    [self unscheduleUpdate];
    move = NO;
}

-(void)setDefaultZ {
    [camera setEyeX:_cameraPosition.x eyeY:_cameraPosition.y eyeZ:[CCCamera getZEye]];
}

-(void)moveCameraZ:(float)zValue {
    cameraZ += zValue;
    
    [camera setEyeX:_cameraPosition.x eyeY:_cameraPosition.y eyeZ:cameraZ];
}

@end

