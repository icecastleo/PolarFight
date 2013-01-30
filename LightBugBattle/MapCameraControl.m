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
const static int kMoveSlowFPS = kGameSettingFps / 3;
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

-(void)moveCameraToX:(float)x Y:(float)y {
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

-(void)smoothMoveCameraToX:(float)x Y:(float)y {
    return [self smoothMoveCameraToX:x Y:y delegate:nil selector:nil];
}

-(void)smoothMoveCameraToX:(float)x Y:(float)y delegate:(id)aTarget selector:(SEL)aSelector {
    if (move) {
        [self unscheduleMove];
    }
    move = YES;
    
    float targetX = MIN(widthLimit, MAX(-1 * widthLimit, x));
    float targetY = MIN(heightLimit, MAX(-1 * heightLimit, y));
    
    moveX = targetX - _cameraPosition.x;
    moveY = targetY - _cameraPosition.y;
    
    float moveLength = ccpLength(ccp(moveX, moveY));
    
    delta = ccpMult(ccpForAngle(atan2f(moveY, moveX)), moveLength / (kMoveTotalFps - (float)kMoveSlowFPS / 2));
    
    // Used for slowdown
    acceleration = ccpMult(delta, 1 / (float)kMoveSlowFPS);
    
    moveCountDown = kMoveTotalFps;
    
    target = aTarget;
    selector = aSelector;
    
    [self scheduleUpdate];
}

-(void)update:(ccTime)deltaTime {
    moveCountDown --;
    
    if (moveCountDown < kMoveSlowFPS) {
        if (moveCountDown == kMoveSlowFPS - 1) {
            delta = ccpSub(delta, ccpMult(acceleration, 0.5));
        } else {
            delta = ccpSub(delta, acceleration);
        }
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
    
    if (moveCountDown == 0) {
        [self unscheduleMove];
        return;
    }
}

-(void)unscheduleMove {
    [self unscheduleUpdate];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (target != nil && selector != nil) {
        [target performSelector:selector];
    }
#pragma clang diagnostic pop    
    
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

