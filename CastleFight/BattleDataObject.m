//
//  BattleDataObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import "BattleDataObject.h"
#import "Character.h"
#import "EnemyAIData.h"

@interface BattleDataObject ()

@property (nonatomic,strong) NSArray *enemyArray;
@property (nonatomic,strong) NSArray *enemyBossArray;
@property (nonatomic,strong) NSArray *enemyCastleArray;

@end

@implementation BattleDataObject

-(id)initWithBattleName:(NSString *)name {
    if (self = [super init]) {
        _battleName = name;
    }
    return self;
}

-(NSArray *)getCharacterArrayFromArray:(NSArray *)array {
    NSMutableArray *tempCharacterArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        MonsterData *monsterData = [[MonsterData alloc] init];
        monsterData.characterId = [dic objectForKey:@"id"];
        monsterData.level = [[dic objectForKey:@"level"] intValue];
        monsterData.targetRatio = [[dic objectForKey:@"targetRatio"] floatValue];
        Character *character = [[Character alloc] initWithId:monsterData.characterId andLevel:monsterData.level];
        monsterData.summonCost = character.cost;
        [tempCharacterArray addObject:monsterData];
    }
    return tempCharacterArray;
}

-(id)initWithBattleDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _battleName = [dic objectForKey:@"name"];
        _mapName = [dic objectForKey:@"map"];
        _backgroundMusic = [dic objectForKey:@"backgroundMusic"];
        
        _enemyArray = [self getCharacterArrayFromArray:[dic objectForKey:@"enemies"]];
        _enemyBossArray = [self getCharacterArrayFromArray:[dic objectForKey:@"bosses"]];
        _enemyCastleArray = [self getCharacterArrayFromArray:[dic objectForKey:@"castle"]];
    }
    return self;
}

-(NSArray *)getEnemyArray {
    return self.enemyArray;
}

-(NSArray *)getEnemyBoss {    
    return self.enemyBossArray;
}

-(Character *)getEnemyCastle {
    MonsterData *data = [self.enemyCastleArray lastObject];
    Character *castle = [[Character alloc] initWithId:data.characterId andLevel:data.level];
    return castle;
}

@end
