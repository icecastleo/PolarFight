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
    
    void(^block)() = ^{
        // FIXME: Better structure?
        DirectionComponent *direction = [[DirectionComponent alloc] initWithVelocity:ccpSub(_finishPosition, _startPosition)];
        direction.spriteDirection = _spriteDirection;
        _sprite.rotation = direction.cocosDegrees;
    };
    
    CCAction *action = [CCSequence actions:
                        [CCCallBlock actionWithBlock:block],
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
    
    CCJumpBy *moveAction = [CCJumpBy actionWithDuration:_duration position:ccpSub(_finishPosition, _startPosition) height:height jumps:1];
    
    CGFloat startDegrees = _startPosition.x > _finishPosition.x ? 135 : 45;
    CGFloat finishDegrees = _startPosition.x > _finishPosition.x ? 225 : 315;
    
    // To cocos degrees
    startDegrees = _spriteDirection - startDegrees;
    finishDegrees = _spriteDirection - finishDegrees;
    
    void(^block)() = ^{
        _sprite.rotation = startDegrees;
    };
    
    CCRotateTo *rotateAction =[CCRotateTo actionWithDuration:_duration angle:finishDegrees];
    
    CCAction *action = [CCSequence actions:
                        [CCCallBlock actionWithBlock:block],
                        [CCSpawn actions:rotateAction, moveAction, nil],
                        nil];
    
    return action;
}

@end
