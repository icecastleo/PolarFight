//
//  BattleController.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleController.h"
#import "CCMoveCharacterTo.h"
#import "CCMoveCharacterBy.h"
#import "BattleStatusLayer.h"
#import "PartyParser.h"
#import "Character.h"
#import "CharacterQueue.h"
#import "HelloWorldLayer.h"
#import "ObjectiveCAdaptor.h"

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

__weak static BattleController* currentInstance;

+(BattleController *)currentInstance {
    return currentInstance;
}

-(id)init {
    if(self = [super init]) {
        currentInstance = self;
        
        // We need a tiled map file to show        
//        mapLayer = [[TiledMapLayer alloc] initWithFile:@"TestMap.tmx"];
        
        mapLayer = [[MapLayer alloc] initWithFile:@"map_01.png"];
        [self addChild:mapLayer];
        
        // init Dpad
        dPadLayer = [DPadLayer node];
        [self addChild:dPadLayer];
        
        characterQueue = [[CharacterQueue alloc] init];
        
        [self setCharacterArrayFromSelectLayer]; //should be above statusLayer.
        statusLayer = [[BattleStatusLayer alloc] initWithBattleController:self andQueue:characterQueue];
        //statusLayer.queue = characterQueue; // For showing Queue Bar.
        [self addChild:statusLayer];
        
        canMove = NO;
        
        [characterQueue roundStart];
        [self scheduleUpdate];
        
        ObjectiveCAdaptor *test = [[ObjectiveCAdaptor alloc] init];
        
        [test objectiveFunc];
    }
    return self;
}

-(NSMutableArray *)characters {
    return mapLayer.characters;
}

- (void)setCharacterArrayFromSelectLayer {
    player1 = [[NSMutableArray alloc] init];
    player2 = [[NSMutableArray alloc] init];
    
    NSArray *characterIdArray;
    characterIdArray = [PartyParser getAllNodeFromXmlFile:@"SelectedCharacters.xml" tagName:@"character" tagAttributeName:@"ol"];
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
    
    for (Character *character in player1) {
        [self addCharacter:character];
//        character.position = ccp(0, -190);
    }
    for (Character *character in player2) {
        [self addCharacter:character];
//        character.position = ccp(0, -240);
    }
    
    player1 = nil;
    player2 = nil;
}

-(void)addCharacter:(Character *)character {
//    CCLOG(@"Add player %i's %@", character.player, character.name);
    [mapLayer addCharacter:character];
    [characterQueue addCharacter:character];
}

-(void)removeCharacter:(Character *)character {
//    CCLOG(@"Remove player %i's %@", character.player, character.name);

    [mapLayer removeCharacter:character];
    [characterQueue removeCharacter:character withAnimated:YES];
    
    // FIXME: Need a manager to control scene
    if (self.characters.count == 0) {
        [self unscheduleUpdate];
        [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
        return;
    }
    
    if(currentCharacter == character) {
        [self roundEnd];
    }
}

-(void)moveCharacter:(Character *)character byPosition:(CGPoint)position isMove:(BOOL)move{
    [mapLayer moveCharacter:character byPosition:position isMove:move];
}

-(void)moveCharacter:(Character *)character toPosition:(CGPoint)position isMove:(BOOL)move{
    [mapLayer moveCharacter:character toPosition:position isMove:move];
}

// FIXME: You should not called isGameOver because you also show the status
-(BOOL)isGameOver {
    // FIXME: Add number to local variable
    int player1Number = 0;
    int player2Number = 0;
    for (Character *character in self.characters) {
        if (character.player == 1) {
            player1Number ++;
        } else if (character.player == 2) {
            player2Number ++;
        }
    }
    BOOL isOver = NO;
    
    if (player1Number == 0 && player2Number != 0) {
        isOver = YES;
        [statusLayer winTheGame:NO];
    }else if (player2Number == 0 && player1Number != 0) {
        isOver = YES;
        [statusLayer winTheGame:YES];
    }
    // FIXME: Tile?
    
    return isOver;
}

-(void)replaceSceneToHelloWorldLayer {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

-(void)knockOut:(Character *)character velocity:(CGPoint)velocity power:(float)power collision:(BOOL)collision {    
    velocity = ccpForAngle(atan2f(velocity.y, velocity.x));
    [character.sprite runAction:[CCEaseOut actionWithAction:[CCMoveCharacterBy actionWithDuration:0.5 character:character position:ccpMult(velocity, power)] rate:2]];
}

-(void)smoothMoveCameraToX:(float)x Y:(float)y {
    if (_state == kGameStateCharacterMove) {
        return;
    }
    
    [mapLayer.cameraControl smoothMoveCameraToX:x Y:y delegate:self selector:@selector(canMove)];
    canMove = NO;
}

-(void)update:(ccTime)delta {
    
    if(!canMove) {
        if (roundStart == NO) {
            [self roundStart];
        }
        return;
    }
    
    if(!isMove && dPadLayer.isButtonPressed) {
        [self characterMove];
    }
    
    if(isMove) {
        [mapLayer.cameraControl moveCameraToX:currentCharacter.position.x Y:currentCharacter.position.y];
        
        countdown -= delta;
        
        if (countdown < 0) {
            countdown = 0;
        }
        
        [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
        
        if(countdown == 0) {
            if(currentCharacter.state == kCharacterStateUseSkill) {
                //FIXME: Might stop more than one time
                [currentCharacter stopSkill];
                return;
            }
            
            [self roundEnd];
            return;
        }
        
        if(dPadLayer.isButtonPressed) {
            if (dPadLayer.velocity.x != 0 || dPadLayer.velocity.y != 0) {
                [currentCharacter setDirection:dPadLayer.velocity];
            }
            
            // Skill will handle for multiple button pressed
            [currentCharacter useSkill];
            return;
        }
        
        if(currentCharacter.state == kCharacterStateUseSkill) {
            return;
        }
        
        // Move character
        [currentCharacter moveBy:ccpMult(dPadLayer.velocity, [currentCharacter getAttribute:kCharacterAttributeSpeed].value * kMoveMultiplier * delta)];
    }
}

-(void)roundStart {
    roundStart = YES;
    isMove = NO;
    _state = kGameStateRoundStart;
    
    currentCharacter = [self getCurrentCharacterFromQueue];
    // TODO:If the player is com, maybe need to change state here!
    // Use state pattern for update??
    
    // Select character
    [statusLayer startSelectCharacter:currentCharacter];
    
    // Set count down for character
    countdown = [currentCharacter getAttribute:kCharacterAttributeTime].value;
    
    // Show count down
    [statusLayer.countdownLabel setString:[NSString stringWithFormat:@"%.2f",countdown]];
    statusLayer.startLabel.visible = YES;
    
    [currentCharacter handleRoundStartEvent];
    
    [mapLayer.cameraControl smoothMoveCameraToX:currentCharacter.position.x Y:currentCharacter.position.y delegate:self selector:@selector(canMove)];
}

-(void)characterMove {
    isMove = YES;
    _state = kGameStateCharacterMove;
    statusLayer.startLabel.visible = NO;
    [statusLayer stopSelect];
}

-(void)roundEnd {
    canMove = NO;
    roundStart = NO;
    _state = kGameStateRoundStart;
    
    if (currentCharacter.state != kCharacterStateDead) {
        [currentCharacter handleRoundEndEvent];
    }
    
    if ([self isGameOver]) {
        [self unscheduleUpdate];
        [self performSelector:@selector(replaceSceneToHelloWorldLayer) withObject:nil afterDelay:3.0];
    }
}

-(void)canMove {
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
