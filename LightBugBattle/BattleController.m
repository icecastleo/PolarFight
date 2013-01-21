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
#import "CharacterQueue.h"
#import "HelloWorldLayer.h"

//@interface SwitchCharacterState : NSObject<GameState> {
//    BOOL run;
//}
//
//@end
//
//@implementation SwitchCharacterState
//
//-(id)init {
//    if(self = [super init]) {
//        run = NO;
//    }
//    return self;
//}
//
//-(void)update:(ccTime)delta {
//    if (run == YES) {
//        return;
//    }
//    
//    run = YES;
//    
//    
//    run = NO;
//}
//
//@end

@interface BattleController () {
    NSMutableArray *player1;
    NSMutableArray *player2;
    CharacterQueue *characterQueue;
}

@end

@implementation BattleController
@dynamic characters;

static int kMoveMultiplier = 40;

static BattleController* currentInstance;

+(BattleController *)currentInstance {
    return currentInstance;
}

-(id)init {
    if(self = [super init]) {
        // We need a map photo to show on the map layer.
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        
        mapLayer = [[MapLayer alloc] initWithMapSprite:map];
        
        CGSize winSize = [CCDirector sharedDirector].winSize;

        [mapLayer setPosition:ccp(winSize.width/2, winSize.height/2)];
        
        [self addChild:mapLayer];
        
        // Testing add barriers
        Barrier* tree = [Barrier spriteWithFile:@"tree01.gif"];
        [tree setPosition:ccp(35,35)];
        [tree setShapeRoundRadius:10 center:ccp(10,-30)];
        [mapLayer addBarrier:tree];
        
        Barrier* tree2 = [Barrier spriteWithFile:@"tree01.gif"];
        [tree2 setPosition:ccp(35,-35)];
        [tree2 setShapeRoundRadius:10 center:ccp(10,-30)];
        [mapLayer addBarrier:tree2];
        
        Barrier* tree3 = [Barrier spriteWithFile:@"tree01.gif"];
        [tree3 setPosition:ccp(-35,35)];
        [tree3 setShapeRoundRadius:10 center:ccp(10,-30)];
        [mapLayer addBarrier:tree3];
        
        Barrier* tree4 = [Barrier spriteWithFile:@"tree01.gif"];
        [tree4 setPosition:ccp(-35,-35)];
        [tree4 setShapeRoundRadius:10 center:ccp(10,-30)];
        [mapLayer addBarrier:tree4];
        
        // init Dpad
        dPadLayer = [DPadLayer node];
        [self addChild:dPadLayer];
        
        [self setCharacterArrayFromSelectLayer]; //should be above statusLayer.
        statusLayer = [[BattleStatusLayer alloc] initWithBattleController:self andQueue:characterQueue];
        //statusLayer.queue = characterQueue; // For showing Queue Bar.
        [self addChild:statusLayer];
        
        canMove = YES;
        isMove = NO;
        
        currentIndex = 0;
//        currentCharacter = self.characters[currentIndex];
        currentCharacter = [self getCurrentCharacterFromQueue];
        
        // start game
        [statusLayer startSelectCharacter:currentCharacter];
        [[mapLayer cameraControl] moveCameraToX:currentCharacter.position.x Y:currentCharacter.position.y];
        
        countdown = [currentCharacter getAttribute:kCharacterAttributeTime].value;
        [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
        [currentCharacter handleRoundStartEvent];
        
        [self scheduleUpdate];        
    }
    currentInstance = self;
    
    return self;
}

-(NSMutableArray *)characters {
    return mapLayer.characters;
}

- (void)setCharacterArrayFromSelectLayer {
    //TODO: will get character from selectLayer fuction.
    player1 = [[NSMutableArray alloc] init];
    player2 = [[NSMutableArray alloc] init];
    
    //here is only for test before selectLayer has done.
    NSArray *characterIdArray;
    if ([PartyParser getAllNodeFromXmlFile:@"SelectedCharacters.xml" tagName:@"character" tagAttributeName:@"ol"]) {
        characterIdArray = [PartyParser getAllNodeFromXmlFile:@"SelectedCharacters.xml" tagName:@"character" tagAttributeName:@"ol"];
    } else {
        Character *character = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:@"AllCharacter.xml" tagName:@"character" tagAttributeName:@"ol" tagAttributeValue:@"000"]];
        character.player = 1;
        [character.sprite addBloodSprite];
        [self addCharacter:character];
        Character *character2 = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:@"AllCharacter.xml" tagName:@"character" tagAttributeName:@"ol" tagAttributeValue:@"000"]];
        character2.player = 2;
        [character2.sprite addBloodSprite];
        [self addCharacter:character2];
        return;
    }
    // Above codes are only for test b/c we are lazy choose characters from selecterLayer always.
    
    //This code is really need after test.
    //characterIdArray = [PartyParser getAllNodeFromXmlFile:@"SelectedCharacters.xml" tagName:@"character" tagAttributeName:@"ol"];
    NSAssert(characterIdArray != nil, @"Ooopse! you forgot to choose some characters.");
    
    for (NSString *characterId in characterIdArray) {
        Character *character = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:@"SelectedCharacters.xml" tagName:@"character" tagAttributeName:@"ol" tagAttributeValue:characterId]];
        character.player = 1;
        [character.sprite addBloodSprite];
        [player1 addObject:character];
    }
    
    NSArray *player2IdArray = [PartyParser getAllNodeFromXmlFile:@"TestPlayer2.xml" tagName:@"character" tagAttributeName:@"ol"];
    
    for (NSString *characterId in player2IdArray) {
        Character *character = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:@"TestPlayer2.xml" tagName:@"character" tagAttributeName:@"ol" tagAttributeValue:characterId]];
        character.player = 2;
        [character.sprite addBloodSprite];
        [player2 addObject:character];
    }
    //characterQueue = [[CharacterQueue alloc] initWithPlayer1Array:player1 andPlayer2Array:player2];
    
    for (Character *character in player1) {
        [self addCharacter:character];
//        character.position = ccp(0, -190);
    }
    for (Character *character in player2) {
        [self addCharacter:character];
//        character.position = ccp(0, -240);
    }
    NSArray *tempArray = [[NSArray alloc] initWithArray:self.characters];
    characterQueue = [[CharacterQueue alloc] initWithCharacterArrayWithRandomTime:tempArray];
    player1 = nil;
    player2 = nil;
}

-(void)addCharacter:(Character *)character {
//    CCLOG(@"Add character : %@",character.name);
    [mapLayer addCharacter:character];
}

-(void)removeCharacter:(Character *)character {
    [mapLayer removeCharacter:character];
    [characterQueue removeCharacter:character];
    
    // FIXME: Need a manage to control scene
    if (self.characters.count == 0) {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
        return;
    }
    
    if(currentCharacter == character) {
        [self endMove];
    }
}

-(void)knockOut:(Character *)character velocity:(CGPoint)velocity power:(float)power collision:(BOOL)collision {
    [mapLayer knockOut:character velocity:velocity power:power collision:collision];
}

-(void)update:(ccTime)delta {
    
    if(!canMove)
        return;
    
    if(!isMove && dPadLayer.isButtonPressed) {
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
            [currentCharacter useSkill];
            return;
        }
        
        // Move character.
        // Character's position control is in mapLayer, so character move should call mapLayer
        [currentCharacter setDirection:dPadLayer.velocity];
        [mapLayer moveCharacter:currentCharacter velocity:ccpMult(dPadLayer.velocity, [currentCharacter getAttribute:kCharacterAttributeSpeed].value * kMoveMultiplier * delta)];
    }
}

-(void) endMove {
    
    canMove = NO;
    
    // 回合結束的檢查 && 設定參數
    isMove = NO;
    
    if (currentCharacter.state != stateDead) {
        [currentCharacter handleRoundEndEvent];
    }

    // TODO: Where is play queue??
    // FIXME: It will caused wrong sequence after someone's dead.
    currentCharacter = [self getCurrentCharacterFromQueue];
    // TODO:If the player is com, maybe need to change state here!
    // Use state pattern for update??
    
    // select character
    [statusLayer startSelectCharacter:currentCharacter];
    
    countdown  = [currentCharacter getAttribute:kCharacterAttributeTime].value;
//    countdown = currentCharacter.moveTime;
    [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
    
    [[mapLayer cameraControl] moveCameraToX:currentCharacter.position.x Y:currentCharacter.position.y];
    [currentCharacter handleRoundStartEvent];
    
    statusLayer.startLabel.visible = YES;
    [self scheduleOnce:@selector(setMoveToYes) delay:2];
    //canMove = YES;
}

-(void)setMoveToYes {
    canMove = YES;
}

-(Character *)getCurrentCharacterFromQueue {
    if ([self.characters containsObject:currentCharacter]) {
        [characterQueue addCharacter:currentCharacter];
    }
    Character *character = [characterQueue pop];
    return character;
}

@end
