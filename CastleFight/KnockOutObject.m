//
//  KnockOutObject.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/12/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "KnockOutObject.h"


@implementation KnockOutObject

-(id)initWithCharacter:(Character *)character velocity:(CGPoint)velocity power:(float)power collision:(BOOL)collision {
    if (self = [super init]) {
        _character = character;
        _velocity = ccpForAngle(atan2f(velocity.y, velocity.x));
        _power = power;
        _collision = collision;
        _count = 0;
        _ratio = 1;
        
        _maxCount = 0.5 * kGameSettingFps;
        _acceleration = 1.0 / _maxCount;
    }
    return self;
}

@end
