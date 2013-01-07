//
//  KnockOutObject.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/12/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "KnockOutObject.h"


@implementation KnockOutObject

-(id)initWithCharacter:(Character *)aCharacter velocity:(CGPoint)aVelocity power:(float)aPower{
    if(self = [super init]) {
        _character = aCharacter;
        _velocity = aVelocity;
        _count = 0;
        _power = aPower;
    }
    return self;
}

@end
