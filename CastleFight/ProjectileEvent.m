//
//  ProjectileEvent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "ProjectileEvent.h"

@implementation ProjectileEvent

-(CCAction *)createProjectileAction {
    if (_type == kProjectileTypeLine) {
        return [self lineAction];
    } else if (_type == kProjectileTypeParabola) {
        return [self parabolaAction];
    }
    return nil;
}

-(CCAction *)lineAction {
    float radians = ccpToAngle(ccpSub(_finishPosition, _startPosition));
    int degrees = CC_RADIANS_TO_DEGREES(radians);
    int cocosDegrees = _spriteDirection - degrees;
    
    CCAction *action = [CCSequence actions:
                        [CCRotateTo actionWithDuration:0.0 angle:cocosDegrees],
                        [CCMoveBy actionWithDuration:_duration position:ccpSub(_finishPosition, _startPosition)],
                        nil];
    
    return action;
}

-(CCAction *)parabolaAction {
    float sx = _startPosition.x;
    float sy = _startPosition.y;
    float fx = _finishPosition.x;
    float fy = _finishPosition.y;
    
    int height = (fx-sx)/2 + (fy-sy)/2;
    // Limit parabola path
    height = MIN(height, kMapPathHeight - kMapPathRandomHeight);
    
    CCJumpBy *moveAction = [CCJumpBy actionWithDuration:_duration position:ccpSub(_finishPosition, _startPosition) height:height jumps:1];
    
    CGFloat startDegrees = _startPosition.x > _finishPosition.x ? 135 : 45;
    // To cocos2d degrees
    startDegrees = _spriteDirection - startDegrees;
    
    CGFloat byDegrees = _startPosition.x > _finishPosition.x ? -90 : 90;
    
//    void(^block)() = ^{
//        _sprite.rotation = startDegrees;
//    };
    
    CCRotateBy *rotateAction =[CCRotateBy actionWithDuration:_duration angle:byDegrees];
    
    CCAction *action = [CCSequence actions:
                        [CCRotateTo actionWithDuration:0.0 angle:startDegrees],
                        [CCSpawn actions:rotateAction, moveAction, nil],
                        nil];
    
    return action;
}

@end
