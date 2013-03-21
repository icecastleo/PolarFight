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
        _currentState =[[AIStateCastleWaiting alloc] init];
        _mutableDictionary = [NSMutableDictionary new];
        [self initMosterData];
        _foodSupplySpeed= 0.8;
        _data = [[EnemyAIData alloc] init];
    }
    return self;
}
// TODO: Get Data from Dan
-(void) initMosterData{
    
    MonsterData *md1= [MonsterData alloc];
    md1.Name=@"001";
    md1.summonCost=20;
    md1.targetRatio=0.25;
    md1.currentCount=0;
    
    
    MonsterData *md2= [MonsterData alloc];
    md2.Name=@"002";
    md2.summonCost=20;
    md2.targetRatio=0.75;
    md2.currentCount=0;
    
    [_data.monsterDataCollection addMonsterDataObject:md1];
    [_data.monsterDataCollection addMonsterDataObject:md2];
    
    
}

-(MonsterDataCollection*) getCurrentMonsters
{
 
    [_data.monsterDataCollection clearCurrentMonsters];
    
    for(Character* temp in [BattleController currentInstance].characters)
    {
        if(temp.player==2)
        {
            MonsterData *item = [_data.monsterDataCollection getMonsterData:temp.characterId];
            item.currentCount++;
            
        }
    
    }
    return _data.monsterDataCollection;
}

@end
