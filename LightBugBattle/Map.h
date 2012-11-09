//
//  Map.h
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapCameraControl.h"

@interface Map : CCNode
{
    int mapBlock[128][53];
    NSMutableArray* characters;
    CCSprite* mapBody;
}

@property (readwrite, assign) MapCameraControl* cameraControl;
-(void) setMap:(CCSprite*)theMap;
-(void) setMapBlocks;
-(void) addCharacter:(CCSprite*) theCharacter position:(CGPoint)location;
-(void) moveCharacter:(CCSprite*)theCharacter velocity:(CGPoint)amount;
-(void) moveCharacterTo:(CCSprite*)theCharacter position:(CGPoint)location;
@end
