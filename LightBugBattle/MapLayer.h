//
//  MapLayer.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapCameraControl.h"
#import "Character.h"

@class Character;
@interface MapLayer : CCLayer {
    int mapBlock[128][53];
    NSMutableArray* characters;
    CCSprite* mapBody;
}

-(void) addCharacter:(Character*)theCharacter;
-(void) removeCharacter:(Character*)theCharacter;


@property (readwrite, assign) MapCameraControl* cameraControl;
-(void) setMap:(CCSprite*)theMap;
-(void) setMapBlocks;
-(void) moveCharacter:(Character*)theCharacter velocity:(CGPoint)amount;
-(void) moveCharacterTo:(Character*)theCharacter position:(CGPoint)location;

@end
