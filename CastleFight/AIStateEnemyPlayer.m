//
//  AIStatePlayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/13.
//
//

#import "AIStateEnemyPlayer.h"
#import "BattleController.h"
#import "TeamComponent.h"
#import "CharacterComponent.h"
#import "PlayerComponent.h"

@implementation EnemyDatas

-(id)init {
    if (self = [super init]) {
        _datas = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)addEnemyData:(EnemyData *)data {
    [_datas setValue:data forKey:data.cid];
}

-(EnemyData *)getEnemyDataWithCid:(NSString *)cid {
    return (EnemyData *)[_datas objectForKey:cid];
}

-(void)zeroCount {
    for (EnemyData *data in _datas.allValues) {
        data.currentCount = 0;
    }
}

@end

@implementation AIStateEnemyPlayer

-(id)initWithEntityFactory:(EntityFactory *)entityFactory {
    if (self = [super init]) {
        _entityFactory = entityFactory;
        enemyDatas = [[EnemyDatas alloc] init];
        
        NSArray *enemys = [BattleController currentInstance].battleData.enemyCharacterDatas;
        
        for (EnemyData *data in enemys) {
            [enemyDatas addEnemyData:data];
        }
    }
    return self;
}

-(void)updateEntity:(Entity *)entity {
    
    PlayerComponent *player = (PlayerComponent *)[entity getComponentOfName:[PlayerComponent name]];
    
    NSArray *entities = [entity getAllEntitiesPosessingComponentOfName:[TeamComponent name]];
    
    // Calculate current enemy count
    [self updateEnemyDatasWithEntities:entities];
    
    if (!nextEnemy) {
        nextEnemy = [self getNextEnemyWithEntity:entity];
    }
    
    while (nextEnemy) {
        if (player.food < nextEnemy.cost) {
            break;
        }
        
        static int count = 0;
        count++;
        
        player.food -= nextEnemy.cost;
        
        // Auto add to map
        [_entityFactory createCharacter:nextEnemy.cid level:nextEnemy.level forTeam:2 addToMap:YES];

        // Add count
        nextEnemy.currentCount++;
        
        nextEnemy = [self getNextEnemyWithEntity:entity];
    }
}

-(EnemyData *)getNextEnemyWithEntity:(Entity *)entity {
        
    int totalCount = 0;
    int totalRatio = 0;
    
    for (EnemyData *data in enemyDatas.datas.allValues) {
        totalCount += data.currentCount;
        totalRatio += data.targetRatio;
    }
    
    int ceil = ceilf((float)totalCount/totalRatio);
    
    if (totalCount % totalRatio == 0) {
        ceil++;
    }
    
    int randomBase = 0;
    
    for (EnemyData *data in enemyDatas.datas.allValues) {
        data.insufficientRatio = data.targetRatio*ceil;
        data.insufficientRatio -= data.currentCount;
        randomBase += data.insufficientRatio;
    }
    
    int random = arc4random_uniform(randomBase) + 1;
    
    for (EnemyData *data in enemyDatas.datas.allValues) {
        random -= data.insufficientRatio;
        
        if (random <= 0) {
            return data;
        }
    }
    
    NSAssert(NO, @"EnemyData must be returned by last for loop!");
    return nil;
}

-(void)updateEnemyDatasWithEntities:(NSArray *)entities {
    [enemyDatas zeroCount];
    
    for (Entity *entity in entities) {
        TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
        
        if (team.team == 1) {
            continue;
        }
        
        CharacterComponent *character = (CharacterComponent *)[entity getComponentOfName:[CharacterComponent name]];
        
        if (character) {
            EnemyData *data = [enemyDatas getEnemyDataWithCid:character.cid];
            data.currentCount++;
        }
    }
}

@end
