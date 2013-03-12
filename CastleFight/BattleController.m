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
#import "BattleSetObject.h"
#import "SimpleAI.h"

@interface BattleController () {
    
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
        
        [self setBattleSetObject];
        mapLayer = [[MapLayer alloc] initWithFile:self.battleSetObject.mapName];
//        mapLayer = [[MapLayer alloc] initWithFile:@"map_01.png"];
        [self addChild:mapLayer];
        
        // set character on may
        [self setCharacterArrayFromSelectLayer];
        
        // init Dpad
        dPadLayer = [DPadLayer node];
        [self addChild:dPadLayer];
        
        statusLayer = [[BattleStatusLayer alloc] initWithBattleController:self];
        [self addChild:statusLayer];
        
        [self scheduleUpdate];
        
        // TODO: Add character also need an array.
        
        // FIXME: Maybe move to maylayer
        removeCharacters = [[NSMutableArray alloc] init];
    }
    return self;
}

-(NSMutableArray *)characters {
    return mapLayer.characters;
}

-(void)setBattleSetObject {
    _battleSetObject = [[BattleSetObject alloc] initWithBattleName:@"battle_01_01"];
    
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"building.plist"];
//    CCSpriteBatchNode *spritesBgNode = [CCSpriteBatchNode batchNodeWithFile:@"building.pvr.ccz"];
}

- (void)setCharacterArrayFromSelectLayer {
    
    NSArray *characterArray;
    
    characterArray = [PartyParser getAllNodeFromXmlFile:[PartyParser loadGDataXMLDocumentFromFileName:@"SelectedCharacters.xml"] tagName:@"character"];
    
    NSAssert(characterArray != nil, @"Ooopse! you forgot to choose some characters.");
    
    for (GDataXMLElement *element in characterArray) {
        Character *character = [[Character alloc] initWithXMLElement:element];
        character.player = 1;
        character.ai = [[SimpleAI alloc] initWithCharacter:character];
        [character.sprite addBloodSprite];
        [self addCharacter:character];
    }
    
    NSArray *player2Array = self.battleSetObject.battleEnemyArray;
    
    for (GDataXMLElement *enemyElement in player2Array) {
        Character *character = [[Character alloc] initWithXMLElement:enemyElement];
        character.player = 2;
        character.ai = [[SimpleAI alloc] initWithCharacter:character];
        [character.sprite addBloodSprite];
        [self addCharacter:character];
    }
    
    GDataXMLDocument *AllCharacterDoc = [PartyParser loadGDataXMLDocumentFromFileName:@"AllCharacter.xml"];
    
    Character *myCastle = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:AllCharacterDoc tagName:@"character" tagAttributeName:@"castle" tagAttributeValue:@"001"]];
    myCastle.player = 1;
    [myCastle.sprite addBloodSprite];
    
    Character *enemyCastle = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:AllCharacterDoc tagName:@"character" tagAttributeName:@"castle" tagAttributeValue:@"001"]];
    enemyCastle.player = 2;
    
    [mapLayer addCastle:myCastle];
    [mapLayer addCastle:enemyCastle];
}

-(void)addCharacter:(Character *)character {
//    CCLOG(@"Add player %i's %@", character.player, character.name);
    [mapLayer addCharacter:character];
}

-(void)removeCharacter:(Character *)character {
//    CCLOG(@"Remove player %i's %@", character.player, character.name);

//    [mapLayer removeCharacter:character];
    [removeCharacters addObject:character];
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
//        [statusLayer winTheGame:NO];
    }else if (player2Number == 0 && player1Number != 0) {
        isOver = YES;
//        [statusLayer winTheGame:YES];
    }
    // FIXME: Tile?
    
    return isOver;
}

-(void)replaceSceneToHelloWorldLayer {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

-(void)knockOut:(Character *)character velocity:(CGPoint)velocity power:(float)power collision:(BOOL)collision {
    // for castle fight
    velocity.y = 0;
    velocity = ccpForAngle(atan2f(velocity.y, velocity.x));
//    [character.sprite runAction:[CCEaseOut actionWithAction:[CCMoveCharacterBy actionWithDuration:0.5 character:character position:ccpMult(velocity, power)] rate:2]];
}

-(void)smoothMoveCameraToX:(float)x Y:(float)y {
    [mapLayer.cameraControl smoothMoveCameraToX:x Y:y delegate:self selector:@selector(canMove)];
    canMove = NO;
}

-(void)canMove {
    canMove = YES;
}

-(void)update:(ccTime)delta {
    for (Character *character in self.characters) {
        [character update:delta];
    }
    
    if (removeCharacters.count > 0) {
        [self.characters removeObjectsInArray:removeCharacters];
        [removeCharacters removeAllObjects];
    }
    
    // TODO: Add character
    // TODO: Check for win or lose
}

@end
