//
//  BattleController.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleController.h"
#import "BattleStatusLayer.h"
#import "PartyParser.h"
#import "Character.h"

@interface SwitchCharacterState : NSObject<GameState>
@end

@implementation SwitchCharacterState

-(void)update:(ccTime)delta {
    
}

@end


@interface SwitchCharacterState : NSObject<GameState>
@end

@implementation SwitchCharacterState

-(void)update:(ccTime)delta {
    
}

@end


@implementation BattleController

static int kMoveMultiplier = 40;

-(id)init {
    if(self = [super init]) {
        
        // init MAP
        mapLayer = [MapLayer node];
        [self addChild:mapLayer];
        
        // first you need a MAP and a layer to put MAP
        // *CCNode can be a layer
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        
        // some map setting
        [map setPosition:ccp(0,0)];
        
        // the camera need to be add into the map layer (it wont display but not adding it will cause error)
        [mapLayer setMap:map];
        
        //testing add barriers
        Barrier* tree = [Barrier spriteWithFile:@"tree01.gif"];
        [tree setPosition:ccp(0,0)];
        [tree setShapeRoundRadius:10 center:ccp(10,-30)];
        [mapLayer addBarrier:tree];
        
        Barrier* tree2 = [Barrier spriteWithFile:@"tree01.gif"];
        [tree2 setPosition:ccp(100,-40)];
        [tree2 setShapeRoundRadius:10 center:ccp(10,-30)];
        [mapLayer addBarrier:tree2];
        
        Barrier* tree3 = [Barrier spriteWithFile:@"tree01.gif"];
        [tree3 setPosition:ccp(-50,30)];
        [tree3 setShapeRoundRadius:10 center:ccp(10,-30)];
        [mapLayer addBarrier:tree3];
        
        Barrier* tree4 = [Barrier spriteWithFile:@"tree01.gif"];
        [tree4 setPosition:ccp(50,10)];
        [tree4 setShapeRoundRadius:10 center:ccp(10,-30)];
        [mapLayer addBarrier:tree4];
        
        // init Dpad
        dPadLayer = [DPadLayer node];
        [self addChild:dPadLayer];
        
        statusLayer = [[BattleStatusLayer alloc] initWithBattleController:self];
        [self addChild:statusLayer];
        
        characters = [[NSMutableArray alloc] init];
        
        [self setCharacterArrayFromSelectLayer];
        
        canMove = YES;
        isMove = NO;
        
        currentIndex = 0;
        currentCharacter = characters[currentIndex];
        
        // start game
        [statusLayer startSelectCharacter:currentCharacter];
        [[mapLayer cameraControl] moveCameraToX:currentCharacter.position.x Y:currentCharacter.position.y];
        
        countdown = [currentCharacter getAttribute:kCharacterAttributeTime].value;
//        countdown = currentCharacter.moveTime;
        [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
        [currentCharacter showAttackRange:YES];
        
        [self scheduleUpdate];
    }
    return self;
}

- (void)setCharacterArrayFromSelectLayer {
    //TODO: will get character from selectLayer fuction.
    
    //here is only for test before selectLayer has done.
    NSString *chrId1 = @"001";
    NSString *chrId2 = @"002";
    NSArray *testCharacterIdArray = [[NSArray alloc] initWithObjects:chrId1,chrId2,nil];
    
    for (NSString *characterId in testCharacterIdArray) {
        Character *character = [[Character alloc] initWithXmlElement:[PartyParser getNodeFromXmlFile:@"Save.xml" TagName:@"character" tagId:characterId]];
        character.player = 1;
        character.controller = self;
        [character.sprite addBloodSprite];
        [self addCharacter:character];
    }
    for (NSString *characterId in testCharacterIdArray) {
        Character *character = [[Character alloc] initWithXmlElement:[PartyParser getNodeFromXmlFile:@"Save.xml" TagName:@"character" tagId:characterId]];
        character.player = 2;
        character.controller = self;
        [character.sprite addBloodSprite];
        [self addCharacter:character];
    }

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
    [mapLayer removeCharacter:character];
    [characters removeObject:character];    
}


-(void)update:(ccTime)delta {
    
    if(!canMove)
        return;
    
    if(!isMove && dPadLayer.isButtonPressed) {
        [[mapLayer cameraControl] followTarget:currentCharacter.sprite];
        isMove = YES;
        statusLayer.startLabel.visible = NO;
        [statusLayer stopSelect];
    }
    
    if(isMove) {
        countdown -= delta;
        
        if (countdown < 0) {
            countdown = 0;
        }
        
        [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
        
        if(countdown == 0) {
            [self endMove];
            return;
        }
        
        if(currentCharacter.state == kCharacterStateUseSkill && currentCharacter.sprite.numberOfRunningActions != 0) {
            return;
        }
        
        if(dPadLayer.isButtonPressed) {
            [currentCharacter useSkill:characters];
            return;
        }
        
        // Move character.
        // Character's position control is in mapLayer, so character move should call mapLayer
        [mapLayer moveCharacter:currentCharacter withVelocity:ccpMult(dPadLayer.velocity, [currentCharacter getAttribute:kCharacterAttributeSpeed].value * kMoveMultiplier * delta)];
    }
}

-(void) endMove {
    canMove = NO;
    
    // 回合結束的檢查 && 設定參數
    isMove = NO;
    [currentCharacter handleRoundEndEvent];

    // TODO: Where is play queue??
    // FIXME: It will caused wrong sequence after someone's dead.
    currentIndex = ++currentIndex % characters.count;
    
    currentCharacter = characters[currentIndex];
    // TODO:If the player is com, maybe need to change state here!
    // Use state pattern for update??
    
    // select character
    [statusLayer startSelectCharacter:currentCharacter];
    [[mapLayer cameraControl] followTarget:currentCharacter.sprite];
    
    countdown  = [currentCharacter getAttribute:kCharacterAttributeTime].value;
//    countdown = currentCharacter.moveTime;
    [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
    
    [currentCharacter handleRoundStartEvent];
    
    statusLayer.startLabel.visible = YES;
    canMove = YES;
}

@end
