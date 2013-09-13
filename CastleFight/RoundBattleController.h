//
//  RoundBattleController.h
//  CastleFight
//
//  Created by 朱 世光 on 13/9/5.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapLayer.h"
#import "DPadLayer.h"
#import "TiledMapLayer.h"
#import "BattleDataObject.h"
@class RoundBattleStatusLayer;

@interface RoundBattleController : CCScene {
    MapLayer *mapLayer;
    RoundBattleStatusLayer *statusLayer;

    NSMutableArray *systems;
}

@property (readonly) int roundTime;

@property (readonly) BattleDataObject *battleData;

@property (readonly) Entity *userPlayer;
@property (readonly) Entity *enemyPlayer;

@property (readonly) Entity *userCastle;
@property (readonly) Entity *enemyCastle;

-(id)initWithPrefix:(int)prefix suffix:(int)suffix;
-(void)smoothMoveCameraTo:(CGPoint)position;

@end
