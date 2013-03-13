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
#import "CharacterBloodSprite.h"

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
    
    _playerCastle = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:AllCharacterDoc tagName:@"character" tagAttributeName:@"castle" tagAttributeValue:@"001"]];
    _playerCastle.player = 1;

    _enemyCastle = [[Character alloc] initWithXMLElement:[PartyParser getNodeFromXmlFile:AllCharacterDoc tagName:@"character" tagAttributeName:@"castle" tagAttributeValue:@"001"]];
    _enemyCastle.player = 2;
    
    [mapLayer addCastle:_playerCastle];
    [mapLayer addCastle:_enemyCastle];
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
    
    [self checkBattleEnd];
}

-(void)checkBattleEnd {
    if (_playerCastle.state == kCharacterStateDead) {
        [statusLayer displayString:@"Lose!!" withColor:ccWHITE];
        [self unscheduleUpdate];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    } else if (_enemyCastle.state == kCharacterStateDead) {
        [statusLayer displayString:@"Win!!" withColor:ccWHITE];
        [self unscheduleUpdate];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    }
}

-(void)endBattle {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

@end
