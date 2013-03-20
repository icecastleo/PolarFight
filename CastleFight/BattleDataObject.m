//
//  BattleDataObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import "BattleDataObject.h"
#import "CharacterData.h"
#import "Character.h"

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
        CharacterData *characterData = [[CharacterData alloc] initWithDictionary:dic];
        [tempCharacterArray addObject:characterData];
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

-(NSArray *)getEnemyBoss {
    
    NSMutableArray *characterArray = [NSMutableArray array];
    
    for (CharacterData *data in self.enemyBossArray) {
        Character *character = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
        [characterArray addObject:character];
    }
    
    return characterArray;
}
-(Character *)getEnemyCastle {
    
    CharacterData *data = [self.enemyCastleArray lastObject];
    Character *castle = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
    return castle;
}

-(NSArray *)getEnemyArray {
    
    NSMutableArray *characterArray = [NSMutableArray array];
    
    for (CharacterData *data in self.enemyArray) {
        Character *character = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
        [characterArray addObject:character];
    }
    
    return characterArray;
}

@end
