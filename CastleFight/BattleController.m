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
#import "Character.h"
#import "CharacterQueue.h"
#import "HelloWorldLayer.h"

#import "SimpleAI.h"
#import "CharacterBloodSprite.h"
#import "FileManager.h"
#import "EnemyAI.h"
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
        self.food = 0;
        foodRate = 0.8;
        
        currentInstance = self;
        
        mapLayer = [[MapLayer alloc] initWithFile:@"map/map_01"];
        [self addChild:mapLayer];
        
        // set character on may
        [self setCharacterArrayFromSelectLayer];
        
        // init Dpad
        //        dPadLayer = [DPadLayer node];
        //        [self addChild:dPadLayer];
        
        statusLayer = [[BattleStatusLayer alloc] initWithBattleController:self];
        [self addChild:statusLayer];
        
        [self scheduleUpdate];
        
        // TODO: Add character also need an array.
        
        // FIXME: Maybe move to maylayer
        removeCharacters = [[NSMutableArray alloc] init];
        
        [self runAction:[CCRepeatForever actionWithAction:
                         [CCSequence actions:
                          [CCCallFunc actionWithTarget:self selector:@selector(foodUpdate)],
                          [CCDelayTime actionWithDuration:0.25],
                          nil]]];
    }
    return self;
}

-(void)setFood:(float)food {
    _food = food;
    [statusLayer updateFood:(int)food];
}

-(void)foodUpdate {
    self.food += foodRate;
}

-(NSMutableArray *)characters {
    return mapLayer.characters;
}

- (void)setCharacterArrayFromSelectLayer {
    
    //test battleData
    _battleData = [FileManager loadBattleInfo:@"battle_01_01"];
    
    _playerCastle = [FileManager getPlayerCastle];
    _playerCastle.player = 1;
    
    _enemyCastle = [_battleData getEnemyCastle];
    _enemyCastle.player = 2;
    
    [mapLayer addCastle:_playerCastle];
    [mapLayer addCastle:_enemyCastle];
    
    _enemyAi = [[EnemyAI alloc] initWithCharacter:_enemyCastle];
    
}

-(void)addCharacter:(Character *)character {
    NSAssert(character.player != 0, @"You must set a player for the character!!");
    
    CCLOG(@"Add player %i's %@", character.player, character.name);
    if (character.player == 1) {
        self.food -= character.cost;
    }
    
    character.ai = [[SimpleAI alloc] initWithCharacter:character];
    [character.sprite addBloodSprite];
    
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
    
    [_enemyAi AIUpdate];
    for (Character *character in self.characters) {
        [character update:delta];
    }
    
    if (removeCharacters.count > 0) {
        for (Character *character in removeCharacters) {
            [mapLayer removeCharacter:character];
        }
        
        [removeCharacters removeAllObjects];
    }
    
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
