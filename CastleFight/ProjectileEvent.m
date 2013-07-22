//
//  ProjectileEvent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "ProjectileEvent.h"

@implementation ProjectileSprite

-(void)setRotation:(float)rotation {
    [super setRotation:rotation];
    
    NSAssert(_direction, @"You should have a direction component!");
    
    int directionDegrees = _direction.spriteDirection - rotation;
    int radians = CC_DEGREES_TO_RADIANS(directionDegrees);
    
    [_direction setVelocity:ccpForAngle(radians)];
}

@end

@implementation ProjectileEvent

-(id)initWithSpriteFile:(NSString *)filename direction:(SpriteDirection)spriteDirection {
    if (self = [super init]) {
        CGPoint velocity = ccpForAngle(CC_DEGREES_TO_RADIANS(spriteDirection));
        
        _direction = [[DirectionComponent alloc] initWithType:kDirectionTypeAllSides velocity:velocity];
        _direction.spriteDirection = spriteDirection;
        
        _sprite = [ProjectileSprite spriteWithFile:filename];
        _sprite.direction = _direction;
    }
    return self;
}

-(id)initWithSpriteFrameName:(NSString *)spriteFrameName direction:(SpriteDirection)spriteDirection {
    if (self = [super init]) {
        CGPoint velocity = ccpForAngle(CC_DEGREES_TO_RADIANS(spriteDirection));
        
        _direction = [[DirectionComponent alloc] initWithType:kDirectionTypeAllSides velocity:velocity];
        _direction.spriteDirection = spriteDirection;
        
        _sprite = [ProjectileSprite spriteWithSpriteFrameName:spriteFrameName];
        _sprite.direction = _direction;
    }
    return self;
}

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
        _direction.velocity = ccpSub(_finishPosition, _startPosition);
        _sprite.rotation = _direction.cocosDegrees;
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
    
    // To cocos2d degrees
    startDegrees = _direction.spriteDirection - startDegrees;
    finishDegrees = _direction.spriteDirection - finishDegrees;
    
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
