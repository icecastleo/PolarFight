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
#import "DPadLayer.h"
#import "MapLayer.h"
#import "Barrier.h"

@class BattleStatusLayer;
@interface BattleController : CCScene {
    
    BattleStatusLayer *statusLayer;
    DPadLayer *dPadLayer;
    MapLayer *mapLayer;
    
    Character *currentCharacter;
    NSMutableArray *characters;
    
    bool canMove;
    bool isMove;
    float countdown;
    
    int currentIndex;
}

//-(Character*) createCharacterWithType:(CharacterType)type;

-(void) addCharacter:(Character*)character;
-(void) removeCharacter:(Character*)character;

@end
