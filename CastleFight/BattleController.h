//
//  BattleController.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Character.h"
#import "MapLayer.h"
#import "DPadLayer.h"
#import "TiledMapLayer.h"
#import "Barrier.h"

@class BattleStatusLayer;

@protocol GameState <NSObject>
-(void)update:(ccTime)delta;
@end

@interface BattleController : CCScene {
    
    BattleStatusLayer *statusLayer;
    DPadLayer *dPadLayer;
    MapLayer *mapLayer;
//    TiledMapLayer *mapLayer;
    
//    id<GameState> state;
    
    Character *currentCharacter;
    
    bool roundStart;
    bool canMove;
    bool isMove;
    float countdown;
    
    int currentIndex;
}

//@property (readonly) DPadLayer *dPadLayer;
//@property (readonly) BattleStatusLayer *statusLayer;
//@property MapLayer *mapLayer;

@property (readonly) GameState state;
@property (readonly) NSMutableArray *characters;

+(BattleController *)currentInstance;

-(void)addCharacter:(Character *)character;
-(void)removeCharacter:(Character *)character;

-(void)moveCharacter:(Character*)character toPosition:(CGPoint)position isMove:(BOOL)move;
-(void)moveCharacter:(Character*)character byPosition:(CGPoint)position isMove:(BOOL)move;

-(void)knockOut:(Character *)character velocity:(CGPoint)velocity power:(float)power collision:(BOOL)collision;
-(void)smoothMoveCameraToX:(float)x Y:(float)y;

@end

