//
//  EnemyAIData.h
//  CastleFight
//
//  Created by 陳 謙 on 13/3/21.
//
//

#import <Foundation/Foundation.h>

@interface MonsterData : NSObject

@property NSString *characterId;
@property int level;
@property float summonCost;
@property int currentCount;
@property float targetRatio;
@property float subRatio;
@end

@interface MonsterDataCollection : NSObject
{
    NSDictionary *monsterData;
}

-(void) addMonsterDataObject:(MonsterData *)object;
-(MonsterData*) getMonsterData:(NSString *)name;
-(void) clearCurrentMonsters;
-(MonsterData*) getNextMonster;
@end


@interface EnemyAIData : NSObject

@property MonsterDataCollection *monsterDataCollection;

@end


