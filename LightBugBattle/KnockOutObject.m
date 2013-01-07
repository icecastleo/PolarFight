//
//  KnockOutObject.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/12/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "KnockOutObject.h"


@implementation KnockOutObject

+(id)objectWithCharacter:(Character *)aCharacter velocity:(CGPoint)aVelocity {
    return [[KnockOutObject alloc] initWithCharacter:aCharacter velocity:aVelocity];
}

-(id)initWithCharacter:(Character *)aCharacter velocity:(CGPoint)aVelocity {
    if(self = [super init]) {
        _character = aCharacter;
        _velocity = aVelocity;
        _count = 0;
        
        [NSTimer scheduledTimerWithTimeInterval:0.025f target:self selector:@selector(update:) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)update:(NSTimer *)timer {
    
    if (_count >= 10) {
        [timer invalidate];
    } else {
        float ratio = powf(0.9, _count);
        CGPoint vel = ccpMult(_velocity, ratio);
        
        _character.position = ccpAdd(_character.position, vel);
        _count++;
    }
}

@end
