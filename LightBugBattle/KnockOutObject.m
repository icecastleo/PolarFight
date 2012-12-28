//
//  KnockOutObject.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/12/28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "KnockOutObject.h"


@implementation KnockOutObject
@synthesize character, velocity, decreaseCount;

-(void) setChar:(Character*) theCharacter vel:(CGPoint)theVelocity
{
    character = theCharacter;
    velocity = theVelocity;
    decreaseCount = 0;
}
@end
