//
//  KnockOutObject.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/12/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "KnockOutObject.h"


@implementation KnockOutObject

-(id)initWithCharacter:(Character *)character velocity:(CGPoint)velocity power:(float)power {
    if (self = [super init]) {
        _character = character;
//        _point = ccpMult(path, 1 / kKnoutOutCount);
        _velocity = ccpForAngle(atan2f(velocity.y, velocity.x));
//        _power = power / kKnoutOutCount;
        _power = power;
        _count = 0;
        _ratio = 1;
    }
    return self;
}

@end
