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
#import "Helper.h"
#import "Barrier.h"
#import "KnockOutObject.h"

@class Character, CharacterInfoView;
@interface MapLayer : CCLayer {
    int mapBlock[128][53];
    
    NSMutableArray *barriers;
    CCSprite *mapSprite;
    
    float boundaryX;
    float boundaryY;
    int zOrder;

    CharacterInfoView *characterInfoView;
}

@property (readonly) NSMutableArray* characters;
@property (readonly) MapCameraControl* cameraControl;

-(id)initWithMapSprite:(CCSprite*)aSprite;

-(void)addCharacter:(Character*)character;
-(void)removeCharacter:(Character*)character;

-(void)addBarrier:(Barrier *)barrier;
//-(void)removeBarrier:(Barrier*)

//-(void)setMapBlocks;
-(void)moveCharacter:(Character*)character toPosition:(CGPoint)position isMove:(BOOL)move;
-(void)moveCharacter:(Character*)character byPosition:(CGPoint)position isMove:(BOOL)move;

@end
