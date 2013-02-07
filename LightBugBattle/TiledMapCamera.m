//
//  TiledMapCamera.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/2/5.
//
//

#import "TiledMapCamera.h"

const static int kMoveTotalFps = kGameSettingFps;
const static int kMoveSlowFPS = kGameSettingFps / 3;
const static int kMoveSlowRatio = 30;

@implementation TiledMapCamera

static float scale;

+(void)initialize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    } else {
        scale = 1.0;
    }
}

-(id)initWithTiledMap:(CCTMXTiledMap *)aMap {
    if (self = [super init]) {
        map = aMap;
        
        CGSize winSize = [CCDirector sharedDirector].winSize;
        
        center = ccp(winSize.width / 2, winSize.height / 2);
        
        widthMax = map.mapSize.width * map.tileSize.width / scale - winSize.width;
        heightMax = map.mapSize.height * map.tileSize.height / scale - winSize.height;
        
        move = NO;
    }
    return self;
}

-(void)moveCameraX:(float)x Y:(float)y {
    [self setMapPosition:ccp(map.position.x - x, map.position.y - y)];
}

-(void)moveCameraToX:(float)x Y:(float)y {
    [self setMapPosition:ccpAdd(ccp(-x, -y), center)];
}

-(void)setMapPosition:(CGPoint)position {
//    NSAssert(!move, @"You can't move camera during a smooth move!");
    if (move) {
//        CCLOG(@"You can't move camera during a smooth move!");
        return;
    }
    
    map.position = ccp(MAX(MIN(0, position.x), -widthMax),MAX(MIN(0, position.y), -heightMax));
}

-(void)smoothMoveCameraToX:(float)x Y:(float)y {
    return [self smoothMoveCameraToX:x Y:y delegate:nil selector:nil];
}

-(void)smoothMoveCameraToX:(float)x Y:(float)y delegate:(id)aTarget selector:(SEL)aSelector {
    if (move) {
        [self unscheduleMove];
    }
    move = YES;
    
    x = -x + center.x;
    y = -y + center.y;
    
    float targetX = MAX(MIN(0, x), -widthMax);
    float targetY = MAX(MIN(0, y), -heightMax);
    
    moveX = targetX - map.position.x;
    moveY = targetY - map.position.y;
    
    float moveLength = ccpLength(ccp(moveX, moveY));
    
    delta = ccpMult(ccpForAngle(atan2f(moveY, moveX)), moveLength / (kMoveTotalFps - (float)kMoveSlowFPS / 2));
    
    // Used for slowdown
    acceleration = ccpMult(delta, 1 / (float)kMoveSlowFPS);
    
    moveCountDown = kMoveTotalFps;
    
    target = aTarget;
    selector = aSelector;
    
    [self scheduleUpdate];
}

-(void)update:(ccTime)deltaTime {
    moveCountDown --;
    
    if (moveCountDown < kMoveSlowFPS) {
        if (moveCountDown == kMoveSlowFPS - 1) {
            delta = ccpSub(delta, ccpMult(acceleration, 0.5));
        } else {
            delta = ccpSub(delta, acceleration);
        }
    }
    
    float updateX;
    float updateY;
    
    if (moveX > 0) {
        updateX = MIN(moveX, delta.x);
    } else {
        updateX = MAX(moveX, delta.x);
    }
    moveX -= updateX;
    
    if (moveY > 0) {
        updateY = MIN(moveY, delta.y);
    } else {
        updateY = MAX(moveY, delta.y);
    }
    moveY -= updateY;

    map.position = ccpAdd(map.position, ccp(updateX, updateY));
    
    if (moveCountDown == 0) {
        [self unscheduleMove];
        return;
    }
}

-(void)unscheduleMove {
    [self unscheduleUpdate];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if (target != nil && selector != nil) {
        [target performSelector:selector];
    }
#pragma clang diagnostic pop
    
    move = NO;
}


@end
