//
//  BattleDataObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import "BattleDataObject.h"
#import "Character.h"
#import "EnemyData.h"

@implementation BattleDataObject

-(id)initWithBattleName:(NSString *)name {
    if (self = [super init]) {
        _battleName = name;
    }
    return self;
}

-(NSArray *)getCharacterDataArrayFromArray:(NSArray *)array {
    NSMutableArray *dataArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        EnemyData *data = [[EnemyData alloc] initWithDictionary:dic];
        [dataArray addObject:data];
    }
    return dataArray;
}

-(id)initWithBattleDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _battleName = [dic objectForKey:@"name"];
        _mapName = [dic objectForKey:@"map"];
        _backgroundMusic = [dic objectForKey:@"backgroundMusic"];
        
        _enemyCharacterDatas = [self getCharacterDataArrayFromArray:[dic objectForKey:@"enemies"]];
        _enemyBossDatas = [self getCharacterDataArrayFromArray:[dic objectForKey:@"bosses"]];
//        _enemyCastleArray = [self getCharacterDataArrayFromArray:[dic objectForKey:@"castle"]];
    }
    return self;
}

//-(Character *)getEnemyCastle {
//    MonsterData *data = [self.enemyCastleArray lastObject];
//    Character *castle = [[Character alloc] initWithId:data.characterId andLevel:data.level];
//    return castle;
//}

@end
