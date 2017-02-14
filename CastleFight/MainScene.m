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
#import "HelloWorldLayer.h"
#import "ShopLayer.h"
#import "MarketLayer.h"
#import "GameCenterLayer.h"

@implementation MainScene

-(id)init {
    if (self = [super init]) {
        layerIndex = 0;
        
        MainStatusLayer *statusLayer = [[MainStatusLayer alloc] initWithMainScene:self];
        [self addChild:statusLayer z:5];
        
        [self run];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"sound_caf/bgm_lobby.caf"];
    }
    return self;
}

-(void)back {
    layerIndex--;
    [self run];
}

-(void)next { 
    layerIndex++;
    [self run];
}

-(void)run {
    [subLayer removeFromParentAndCleanup:YES];
    
    switch (layerIndex) {
        case -1:
            [[CCDirector sharedDirector] replaceScene:[HelloWorldLayer scene]];
            break;
        case 0:
            subLayer = [[ShopLayer alloc] init];
            [self addChild:subLayer];
            break;
        case 1:
            subLayer = [[StageScrollLayer alloc] init];
            subLayer.position = ccp(0, -15);
            [self addChild:subLayer];
            break;
        case 2:
            subLayer = [[GameCenterLayer alloc] init];
            subLayer.position = ccp(0, -15);
            [self addChild:subLayer];
            break;
        default:
            break;
    }
}

-(void)dealloc {
//    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
