//
//  CCUntouchableLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/8/22.
//
//

#import "CCUntouchableLayer.h"

@implementation CCUntouchableLayer

-(id)init {
    if ((self = [super initWithColor:ccc4(50, 50, 50, 150)])) {
        [self setTouchEnabled:YES];
    }
    return self;
}

-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kTouchPriotiryUntouchable swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

@end
