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
#import "CharacterInfoView.h"

@class Character;
@interface MapLayer : CCLayer {        
    int mapBlock[128][53];
//    NSMutableArray *characters;
    NSMutableArray *barriers;
    CCSprite *mapBody;
    
    CharacterInfoView *characterInfoView;
}

@property (strong, readonly) NSMutableArray* characters;
@property (weak, readonly) MapCameraControl* cameraControl;

-(id)initWithMapSprite:(CCSprite*)aSprite;

-(void)addCharacter:(Character*)theCharacter;
-(void)removeCharacter:(Character*)theCharacter;

-(void)addBarrier:(Barrier *)theBarrier;
//-(void) removeBarrier:(Barrier*)

//-(void) setMap:(CCSprite*)theMap;
-(void)setMapBlocks;
-(void)moveCharacter:(Character*)theCharacter velocity:(CGPoint)velocity;
-(void)moveCharacterTo:(Character*)theCharacter position:(CGPoint)location;
-(void)knockOut:(Character*)character velocity:(CGPoint)velocity power:(float)power collision:(BOOL)collision;
@end
