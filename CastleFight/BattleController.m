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
#import "HeroAI.h"
#import "SimpleAI.h"
#import "CharacterBloodSprite.h"
#import "FileManager.h"
#import "EnemyAI.h"
#import "SimpleAudioEngine.h"

@interface BattleController () {
    
}
@end

@implementation BattleController
@dynamic characters;

__weak static BattleController* currentInstance;

const float foodAddend = 0.05;

+(BattleController *)currentInstance {
    return currentInstance;
}

-(id)init {
    if(self = [super init]) {
        // FIXME: set by init
        NSString *prefix = @"01";
        NSString *suffix = @"01";
        
        self.food = 0;
        // TODO: Set by init, maybe can upgrade
        foodRate = 1.0f;
        maxRate = foodRate * 4;
        
        currentInstance = self;
        
        _battleData = [[FileManager sharedFileManager] loadBattleInfo:[NSString stringWithFormat:@"%@_%@", prefix, suffix]];
        NSAssert(_battleData != nil, @"you do not load the correct battle's data.");
        
        mapLayer = [[MapLayer alloc] initWithFile:[NSString stringWithFormat:@"map/map_%@", prefix]];
        [self addChild:mapLayer];
        
        // set character on may
        [self setCharacterArrayFromSelectLayer];
        
        // init Dpad
        //        dPadLayer = [DPadLayer node];
        //        [self addChild:dPadLayer];
        
        statusLayer = [[BattleStatusLayer alloc] initWithBattleController:self];
        [self addChild:statusLayer];
        _hero = [[Character alloc] initWithId:@"209" andLevel:1];
        _hero.player = 1;
       
        [_hero.sprite addBloodSprite];
        [self addCharacter:_hero];
         _hero.ai = [[HeroAI alloc] initWithCharacter:_hero];
        [self scheduleUpdate];
        
        // FIXME: Maybe move to maylayer
        removeCharacters = [[NSMutableArray alloc] init];
        
        [self runAction:[CCRepeatForever actionWithAction:
                         [CCSequence actions:
                          [CCCallFunc actionWithTarget:self selector:@selector(foodUpdate)],
                          [CCDelayTime actionWithDuration:0.25],
                          nil]]];
        
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"sound_caf/bgm_battle%d.caf", [prefix intValue]]];
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
    
    _playerCastle = [[FileManager sharedFileManager] getPlayerCastle];
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

        if (foodRate < maxRate) {
//            foodRate += character.cost / 200.0;
            foodRate += foodAddend;
        }
    }
    
    [self setAI:character];
    [character.sprite addBloodSprite];
    
    [mapLayer addCharacter:character];
}

-(void)setAI:(Character *)character {
    if ([character.characterId intValue] < 200) {
        character.ai = [[SimpleAI alloc] initWithCharacter:character];
    } else if ([character.characterId hasPrefix:@"3"]) {
        // TODO: boss AI
    }
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
    [_hero.ai AIUpdate];
    for (Character *character in self.characters) {
        [character update:delta];
    }
    
    if (removeCharacters.count > 0) {
        for (Character *character in removeCharacters) {
            [mapLayer removeCharacter:character];
        }
        
        [removeCharacters removeAllObjects];
    }
    if(mapLayer.isFollowing)
        [mapLayer.cameraControl limitMoveCameraToX:_hero.position.x Y:_hero.position.y];
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

-(void)dealloc {
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
