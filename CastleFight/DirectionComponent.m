
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
        NSAssert(velocity.x != 0 || velocity.y != 0, @"This is not a legal direction velocity!");
        self.velocity = velocity;
    }
    return self;
}

-(void)setVelocity:(CGPoint)velocity {
    if (velocity.x == 0 && velocity.y == 0) {
        return;
    }
    
    if(roundf(ccpLength(velocity)) != 1) {
        velocity = ccpNormalize(velocity);
    }
    
    _velocity = velocity;
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

@end
