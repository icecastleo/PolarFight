//
//  MainScene.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/1.
//
//

#import "MainScene.h"
#import "MainStatusLayer.h"
#import "SimpleAudioEngine.h"
#import "StageScrollLayer.h"

@implementation MainScene

-(id)init {
    if (self = [super init]) {
        MainStatusLayer *statusLayer = [[MainStatusLayer alloc] initWithMainScene:self];
        [self addChild:statusLayer z:5];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"sound_caf/bgm_lobby.caf"];
    }
    return self;
}

-(void)addStageLayer {
    [subLayer removeFromParentAndCleanup:YES];
    
    subLayer = [[StageScrollLayer alloc] init];
    subLayer.position = ccp(0, -15);
    [self addChild:subLayer];
}

-(void)dealloc {
//    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
