//
//  RoundBattleController.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/5.
//
//

#import "RoundBattleController.h"
#import "RoundBattleStatusLayer.h"
#import "HelloWorldLayer.h"
#import "CharacterBloodSprite.h"
#import "FileManager.h"
#import "SimpleAudioEngine.h"
#import "AchievementManager.h"
#import "EntityManager.h"
#import "EntityFactory.h"
#import "PlayerSystem.h"
#import "AISystem.h"
#import "MoveSystem.h"
#import "ProjectileSystem.h"
#import "ActiveSkillSystem.h"
#import "CombatSystem.h"
#import "EffectSystem.h"
#import "DefenderComponent.h"
#import "PlayerComponent.h"
#import "PhysicsSystem.h"
#import "TouchSystem.h"
#import "OrbSystem.h"

#import "OrbBoardComponent.h"
#import "TouchComponent.h"
#import "RenderComponent.h"
#import "MagicSystem.h"

#import "TopLineMapLayer.h"
#import "BattleCatMapLayer.h"
#import "ThreeLineMapLayer.h"

typedef enum {
    kBattleStatusWait,
    kBattleStatusOrb,
    kBattleStatusPrepareFight,
    kBattleStatusFight,
} BattleStatus;

@interface RoundBattleController () {
    NSString *battleName;
    
    EntityManager *entityManager;
    EntityFactory *entityFactory;
    
    TouchSystem *touchSystem;
    
    BattleStatus status;
    OrbBoardComponent *board;
    
    float fightTime;
}
@end

@implementation RoundBattleController

-(id)initWithPrefix:(int)prefix suffix:(int)suffix {
    if(self = [super init]) {
        status = kBattleStatusOrb;
        
        battleName = [NSString stringWithFormat:@"%02d_%02d", prefix, suffix];
        
        _battleData = [[FileManager sharedFileManager] loadBattleInfo:[NSString stringWithFormat:@"%02d - %02d", prefix, suffix]];
        NSAssert(_battleData != nil, @"you do not load the correct battle's data.");
        
        mapLayer = [[ThreeLineMapLayer alloc] initWithName:[NSString stringWithFormat:@"map/map_%02d", prefix]];
        [self addChild:mapLayer];
        
        entityManager = [[EntityManager alloc] init];
        entityFactory = [[EntityFactory alloc] initWithEntityManager:entityManager];
        entityFactory.mapLayer = mapLayer;
        
        PhysicsSystem *physicsSystem = [[PhysicsSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory];
        entityFactory.physicsSystem = physicsSystem;
        
        _userPlayer = [entityFactory createUserPlayerForTeam:1];
        _enemyPlayer = [entityFactory createEnemyPlayerForTeam:2 battleData:_battleData];
        
        systems = [[NSMutableArray alloc] init];
        [systems addObject:physicsSystem];
        [self setSystem];
        
        // init Dpad
        //        dPadLayer = [DPadLayer node];
        //        [self addChild:dPadLayer];
        
        statusLayer = [[RoundBattleStatusLayer alloc] init];
        [self addChild:statusLayer];
        
        Entity *entity = [entityFactory createOrbBoardWithUser:_userPlayer AIPlayer:_enemyPlayer andBattleData:_battleData];
        board = (OrbBoardComponent *)[entity getComponentOfName:[OrbBoardComponent name]];
        board.timeCountdown = 1;
        
        [self runAction:[CCSequence actions:
                         [CCCallBlock actionWithBlock:^{
            [statusLayer displayString:@"Ready" withColor:ccGOLD];
        }], [CCDelayTime actionWithDuration:1.5f],
                         [CCCallBlock actionWithBlock:^{
            [statusLayer displayString:@"Go!!" withColor:ccGOLD];
        }], [CCDelayTime actionWithDuration:1.5f],
                         [CCCallBlock actionWithBlock:^{
            board.status = kOrbBoardStatusStart;
        }],nil]];
        
        [self scheduleUpdate];
    }
    return self;
}

-(void)onEnter {
    [super onEnter];
    
    touchSystem = [[TouchSystem alloc] initWithEntityManager:entityManager];
    [self addChild:touchSystem];
    
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:touchSystem priority:kTouchPriorityTouchSystem swallowsTouches:YES];
    
    //    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"sound_caf/bgm_battle%d.caf", _prefix]];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"music_1.caf"];
}

-(void)onExit {
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:touchSystem];
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    
    [super onExit];
}

-(void)setSystem {
    [systems addObject:[[AISystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[ActiveSkillSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[MagicSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[CombatSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[MoveSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[EffectSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[ProjectileSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[PlayerSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
    [systems addObject:[[OrbSystem alloc] initWithEntityManager:entityManager entityFactory:entityFactory]];
}

-(void)smoothMoveCameraTo:(CGPoint)position {
    [mapLayer.cameraControl smoothMoveTo:position duration:1.0f];
}

-(void)update:(ccTime)delta {
    if (status == kBattleStatusOrb) {
        for (System *system in systems) {
            [system update:delta];
        }
        
        // TODO: change color or special effect!
        [statusLayer.timeLabel setString:[NSString stringWithFormat:@"%d", (int)board.timeCountdown]];
        
        if (board.status == kOrbBoardStatusEnd) {
//            [statusLayer displayString:@"Finish!!" withColor:ccGOLD];
            // TODO: Change to fight!
            status = kBattleStatusPrepareFight;
        }
    }
    
    if (status == kBattleStatusPrepareFight) {
        [entityFactory createGroupCharacter:@"001" withCount:20 forTeam:1];
        [entityFactory createGroupCharacter:@"002" withCount:20 forTeam:1];
        [entityFactory createGroupCharacter:@"003" withCount:20 forTeam:1];
        [entityFactory createGroupCharacter:@"004" withCount:20 forTeam:1];
        [entityFactory createGroupCharacter:@"101" withCount:20 forTeam:2];
        [entityFactory createGroupCharacter:@"102" withCount:20 forTeam:2];
        [entityFactory createGroupCharacter:@"103" withCount:20 forTeam:2];
        [entityFactory createGroupCharacter:@"104" withCount:20 forTeam:2];
        [entityFactory createGroupCharacter:@"105" withCount:20 forTeam:2];
        [entityFactory createGroupCharacter:@"106" withCount:20 forTeam:2];
        
        [entityFactory createGroupCharacter:@"201" withCount:20 forTeam:1];
        status = kBattleStatusWait;
        
        [self runAction:[CCSequence actions:
                         [CCCallBlock actionWithBlock:^{
            [statusLayer displayString:@"Ready" withColor:ccGOLD];
        }], [CCDelayTime actionWithDuration:1.5f],
                         [CCCallBlock actionWithBlock:^{
            [statusLayer displayString:@"Fight!!" withColor:ccGOLD];
        }], [CCDelayTime actionWithDuration:1.5f],
                         [CCCallBlock actionWithBlock:^{
            status = kBattleStatusFight;
        }],nil]];
        
    }
    
    if (status == kBattleStatusFight) {
        fightTime += delta;
        [statusLayer.timeLabel setString:[NSString stringWithFormat:@"%d", (int)fightTime]];
        
        for (System *system in systems) {
            [system update:delta];
        }
        
        [self checkBattleEnd];
    }
}

-(void)checkBattleEnd {
    PlayerComponent *userPlayer = (PlayerComponent *)[_userPlayer getComponentOfName:[PlayerComponent name]];
    PlayerComponent *enemyPlayer = (PlayerComponent *)[_enemyPlayer getComponentOfName:[PlayerComponent name]];
    
    if (userPlayer.armiesCount == 0) {
        [statusLayer displayString:@"Lose!!" withColor:ccWHITE];
        [self unscheduleUpdate];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    } else if (enemyPlayer.armiesCount == 0) {
        [statusLayer displayString:@"Win!!" withColor:ccWHITE];
        
        [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_completed"]] Value:1];
        
        //FIXME: calculate the number of star.
        int stars = 2; // fix it.
        int oldStars = [[FileManager sharedFileManager].achievementManager getValueFromProperty:[battleName stringByAppendingString:@"_star"]];
        
        [[FileManager sharedFileManager].achievementManager resetPropertiesWithTags:@[battleName,@"star"]];
        if (oldStars < stars) {
            [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_star"]] Value:stars];
        } else {
            [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_star"]] Value:oldStars];
        }
        
        [[FileManager sharedFileManager].achievementManager checkAchievementsForTags:nil];
        
        [self unscheduleUpdate];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    }
}

-(void)endBattle {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

@end
