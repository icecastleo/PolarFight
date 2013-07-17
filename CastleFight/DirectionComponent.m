
//
//  DirectionComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/9.
//
//

#import "DirectionComponent.h"
#import "cocos2d.h"

@implementation DirectionComponent

-(id)initWithVelocity:(CGPoint)velocity {
    if (self = [super init]) {
        _spriteDirection = kSpriteDirectionNone;
        
        _type = kDirectionTypeLeftRight;
        
        NSAssert(velocity.x != 0 || velocity.y != 0, @"This is not a legal direction velocity!");
        self.velocity = velocity;
    }
    return self;
}

-(void)setVelocity:(CGPoint)velocity {
    if (velocity.x == 0 && velocity.y == 0) {
        return;
    }
    
    switch (_type) {
        case kDirectionTypeLeftRight:
            _velocity = ccp(velocity.x, 0);
            break;
        case kDirectionTypeUpDown:
            _velocity = ccp(0, velocity.y);
            break;
        case kDirectionTypeFourSides:
            if(fabsf(_velocity.x) >= fabsf(_velocity.y)) {
                if(_velocity.x > 0) {
                    _velocity = ccp(1, 0);
                } else {
                    _velocity = ccp(-1, 0);
                }
            } else {
                if(_velocity.y > 0) {
                    _velocity = ccp(0, 1);
                } else {
                    _velocity = ccp(0, -1);
                }
            }
            break;
        case kDirectionTypeAllSides:
            _velocity = velocity;
            break;
        default:
            NSAssert(NO, @"Did you define a wrong type?");
            break;
    }
    
    // Normalize velocity
    if(roundf(ccpLength(_velocity)) != 1) {
        _velocity = ccpNormalize(_velocity);
    }
}

-(Direction)direction {
//    if (_velocity.x == 0 && _velocity.y == 0) {
//        return kDirectionNone;
//    }
    
    if(fabsf(_velocity.x) >= fabsf(_velocity.y)) {
        if(_velocity.x > 0) {
            return kDirectionRight;
        } else {
            return kDirectionLeft;
        }
    } else {
        if(_velocity.y > 0) {
            return kDirectionUp;
        } else {
            return kDirectionDown;
        }
    }
}

-(float)radians {
    return atan2f(_velocity.y, _velocity.x);
}

-(float)cocosDegrees {
    // The sprite will not rotate
    if (_spriteDirection == kSpriteDirectionNone) {
        return 0;
    }
    
    float radians = self.radians;
    float angleDegrees = CC_RADIANS_TO_DEGREES(radians);
    return _spriteDirection - angleDegrees;
}

@end
