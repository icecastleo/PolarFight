//
//  StageLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/29.
//
//

#import "StageScrollLayer.h"

@implementation StageScrollLayer

+(void)initialize {
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"selstagebutton.plist"];
}

-(id)init {
    if (self = [super init]) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        NSArray *layers = [[NSArray alloc] init];
        
        
        layer = [[CCScrollLayer alloc] initWithLayers:nil widthOffset:winSize.width];
    }
    return self;
}

@end
