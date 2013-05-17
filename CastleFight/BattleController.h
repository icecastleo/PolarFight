//
//  BattleController.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapLayer.h"
#import "DPadLayer.h"
#import "TiledMapLayer.h"
#import "BattleDataObject.h"
@class BattleStatusLayer;

@interface BattleController : CCScene {
    MapLayer *mapLayer;
    BattleStatusLayer *statusLayer;
//    DPadLayer *dPadLayer;

    NSMutableArray *systems;
}

@property (readonly) BattleDataObject *battleData;

@property (readonly) Entity *userPlayer;
@property (readonly) Entity *enemyPlayer;

@property (readonly) Entity *userCastle;
@property (readonly) Entity *enemyCastle;

+(BattleController *)currentInstance;

-(id)initWithPrefix:(int)prefix suffix:(int)suffix;

-(void)smoothMoveCameraTo:(CGPoint)position;

@end

