//
//  BattleController.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleController.h"
#import "BattleStatusLayer.h"

@implementation BattleController

-(id)init {
    if(self = [super init]) {
        
        
        
        
        //////MAPPPPP///
        mapLayer = [MapLayer node];
        [self addChild:mapLayer];
        
        //first you need a MAP and a layer to put MAP
        //*CCNode can be a layer
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        
        
        //some map setting
        [map setPosition:ccp(0,0)];
        
        
        //the camera need to be add into the map layer
        //(it wont display but not adding it will cause error)
        [mapLayer setMap:map];
        
        
        
        
        
        
        
        dPadLayer = [[DPadLayer alloc] init];
        [self addChild:dPadLayer];
        
        statusLayer = [[BattleStatusLayer alloc] initWithBattleController:self];
        [self addChild:statusLayer];
        
        characters = [[NSMutableArray alloc] init];
        
        int number = 2;
        
        for (int i = 0; i < number; i++) {
            Character *character = [Character characterWithController:self player:1 withFile:@"amg1"];
            [self addCharacter:character];
        }
        
        for (int i = 0; i < number; i++) {
            Character *character = [Character characterWithController:self player:2 withFile:@"avt1"];
            [self addCharacter:character];
        }
        
        canMove = YES;
        isMove = NO;
        
        currentIndex = 0;
        currentCharacter = characters[currentIndex];
        
        //start game
        [statusLayer startSelectCharacter:currentCharacter];
        [[mapLayer cameraControl] moveCameraToX:currentCharacter.position.x Y:currentCharacter.position.y];
        
        countdown = currentCharacter.moveTime;
        [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
        [currentCharacter showAttackRange:YES];
        
        [self scheduleUpdate];
    }
    return self;
}

//-(Character *)createCharacterWithType:(CharacterType)type {
//    // TODO: All
//    return nil;
//}

-(void)addCharacter:(Character *)character {
    [characters addObject:character];
    [mapLayer addCharacter:character];
}

-(void)removeCharacter:(Character *)character {
    [characters removeObject:character];
    [character.sprite removeFromParentAndCleanup:YES];
    [character release];
//    [mapLayer removeCharacter:character];
}

-(void)dealloc {    
    [characters release];
    [statusLayer release];
    [dPadLayer release];
    [mapLayer release];
    [super dealloc];
}


- (void) update:(ccTime) delta {
    
    if(!canMove)
        return;
    
    if(!isMove && dPadLayer.pressButton) {
        [[mapLayer cameraControl] followTarget:currentCharacter.sprite];
        isMove = YES;
        statusLayer.startLabel.visible = NO;
        [statusLayer stopSelect];
        return;
    }
    
    if(isMove) {
        countdown -= delta;
        
        if (countdown < 0) {
            countdown = 0;
        }
        
        [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
        
        if(countdown == 0) {
            [currentCharacter end];
            [self endMove];
            return;
        }
        
        if(currentCharacter.state == stateAttack && currentCharacter.sprite.numberOfRunningActions != 0) {
            return;
        }
        
        if(dPadLayer.pressButton) {
            [currentCharacter attackEnemy:characters];
            return;
        }
        
        if(dPadLayer.velocity.x!=0 && dPadLayer.velocity.y!=0)
            [currentCharacter setAttackRotation:dPadLayer.velocity.x :dPadLayer.velocity.y];
        
        //[currentCharacter addPosition:dPadLayer.velocity time:delta];
        //
        // CHARACTER MOVE
        //
        // Character position control is in mapLayer
        // so character move should call maplayer
        CGPoint vol = ccp( dPadLayer.velocity.x * 5, dPadLayer.velocity.y * 5 );
        [mapLayer moveCharacter:currentCharacter velocity:vol];
    }
}

-(void) endMove {
    canMove = NO;
    
    // 回合結束的檢查 && 設定參數
    
    isMove = NO;
    [currentCharacter showAttackRange:NO];
    statusLayer.startLabel.visible = YES;
    
    currentIndex = ++currentIndex % characters.count;
    
    currentCharacter = characters[currentIndex];
    
    //select player
    [statusLayer startSelectCharacter:currentCharacter];
    [[mapLayer cameraControl] followTarget:currentCharacter.sprite];
    
    [currentCharacter showAttackRange:YES];
    countdown = currentCharacter.moveTime;
    [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
    
    canMove = YES;
}

@end
