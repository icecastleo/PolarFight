//
//  MenuScene.m
//  CastleFight
//
//  Created by 朱 世光 on 13/10/15.
//
//

#import "MenuScene.h"
#import "MenuLayer.h"

@implementation MenuScene

-(id)init {
    if (self = [super init]) {
        MenuLayer *menuLayer = [[MenuLayer alloc] init];
        [self addChild:menuLayer];
    }
    return self;
}

@end
