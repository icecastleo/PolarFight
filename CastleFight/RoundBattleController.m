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

#import "CharacterInitData.h"
#import "EnemyData.h"
#import "OrbSkill.h"

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
    
    NSArray *activeSkills;
    
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
        
//        statusLayer = [[RoundBattleStatusLayer alloc] init];
        statusLayer = [[RoundBattleStatusLayer alloc] initWithBattleController:self];
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
        
        [statusLayer setMagicButton];
        [statusLayer setItemButton];
        
        PlayerComponent *playerCom = (PlayerComponent *)[self.userPlayer getComponentOfName:[PlayerComponent name]];
        
        NSDictionary *orbInfo = [playerCom orbInfo];
        for (NSString *key in orbInfo) {
            NSNumber *sum = [orbInfo objectForKey:key];
            CCLOG(@"color:%@, sum:%d",key,sum.intValue);
        }
        
        activeSkills = [playerCom activeSkills];
        
        int bonusCount = 0;
        float bonusMana = 0;
        for (OrbSkill *orbSkill in activeSkills) {
            if (orbSkill.skillType == OrbSkillTypePrepareBattle) {
                if ([orbSkill respondsToSelector:@selector(characterBonusCount)]) {
                    bonusCount += [orbSkill characterBonusCount];
                }
                if ([orbSkill respondsToSelector:@selector(bonusMana)]) {
                    bonusMana += [orbSkill bonusMana];
                }
            }
        }
        
        //FIXME: suppose the max of mana is 100
        int maxMana = 100;
        playerCom.mana += maxMana * bonusMana;
        CCLOG(@"Add Mana: from %f to %f",playerCom.mana-maxMana * bonusMana,playerCom.mana);
        [statusLayer.manaLabel setString:[NSString stringWithFormat:@"%d", (int)playerCom.mana]];
        
        // create characters from user battleTeam.
        NSArray *battleTeamInitData = [FileManager sharedFileManager].battleTeam;
        for (int i=0; i<battleTeamInitData.count; i++) {
            int count = [[orbInfo objectForKey:[NSNumber numberWithInt:i+1]] intValue];
            CharacterInitData *data = [battleTeamInitData objectAtIndex:i];
            NSArray *groupEntities = [entityFactory createGroupCharacter:data.cid withCount:count forTeam:kPlayerTeam BonusCount:bonusCount];
            
            for (Entity *entity in groupEntities) {
                for (OrbSkill *orbSkill in activeSkills) {
                    if (orbSkill.skillType == OrbSkillTypePrepareBattle && [orbSkill respondsToSelector:@selector(affectOnEntity:)]) {
                        [orbSkill affectOnEntity:entity];
                    }
                }
            }
        }
        
        // create characters from battleData.
        NSArray *enemies = self.battleData.enemyCharacterDatas;
        for (int i=0; i<enemies.count; i++) {
            EnemyData *data = [enemies objectAtIndex:i];
            
            //FIXME:count might load from battleData.
            [entityFactory createGroupCharacter:data.cid withCount:20 forTeam:kEnemyTeam BonusCount:0];
        }
        
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
        PlayerComponent *playerCom = (PlayerComponent *)[self.userPlayer getComponentOfName:[PlayerComponent name]];
        [statusLayer.manaLabel setString:[NSString stringWithFormat:@"%d", (int)playerCom.mana]];
        
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
        [statusLayer removeChildByTag:kPauseMenuTag cleanup:YES];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    } else if (enemyPlayer.armiesCount == 0) {
        [statusLayer displayString:@"Win!!" withColor:ccWHITE];
        
        //FIXME: calculate the Reward.
        int coins = 1000;
        for (OrbSkill *orbSkill in activeSkills) {
            if (orbSkill.skillType == OrbSkillTypeAfterBattle) {
                if ([orbSkill respondsToSelector:@selector(bonusReward)]) {
                    coins += coins*[orbSkill bonusReward];
                }
            }
        }
        CCLOG(@"You get %d coins!",coins);
        
        [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_completed"]] Value:1];
        
        //FIXME: calculate the number of star.
        int stars = 2;
        int oldStars = [[FileManager sharedFileManager].achievementManager getValueFromProperty:[battleName stringByAppendingString:@"_star"]];
        
        if (oldStars < stars) {
            [[FileManager sharedFileManager].achievementManager resetPropertiesWithTags:@[battleName,@"star"]];
            [[FileManager sharedFileManager].achievementManager addValueForPropertyNames:@[[battleName stringByAppendingString:@"_star"]] Value:stars];
        }
        
        [[FileManager sharedFileManager].achievementManager checkAchievementsForTags:nil];
        
        [self unscheduleUpdate];
        [statusLayer removeChildByTag:kPauseMenuTag cleanup:YES];
        [self performSelector:@selector(endBattle) withObject:nil afterDelay:3.0];
    }
}

-(void)endBattle {
    [[CCDirector sharedDirector] replaceScene:[CCTransitionZoomFlipX transitionWithDuration:0.5 scene:[HelloWorldLayer scene]]];
}

@end
