//
//  CastleAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "EnemyAI.h"
#import "AIStateCastleWaiting.h"
#import "Character.h"
#import "BattleController.h"
@implementation EnemyAI

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        _currentState = [[AIStateCastleWaiting alloc] init];
        _mutableDictionary = [NSMutableDictionary new];
         _data = [[EnemyAIData alloc] init];
        [self initMosterData];
        _foodSupplySpeed = 3;
        _food = 20;
    }
    return self;
}

-(void)initMosterData {    
    NSArray *enemyArry = [[BattleController currentInstance].battleData getEnemyArray];
    
    for (MonsterData *item in enemyArry) {        
         [_data.monsterDataCollection addMonsterDataObject:item];
    }
}

-(MonsterDataCollection*) getCurrentMonsters {
    [_data.monsterDataCollection clearCurrentMonsters];
    
    for(Character* temp in [BattleController currentInstance].characters)
    {
        if(temp.player == 2)
        {
            MonsterData *item = [_data.monsterDataCollection getMonsterData:temp.characterId];
            item.currentCount++;
        }
    }
    return _data.monsterDataCollection;
}

@end
