//
//  BattleDataObject.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import <Foundation/Foundation.h>

@class Character;

@interface BattleDataObject : NSObject

@property (nonatomic,readonly) NSString *battleName;

//battle info
@property (readonly) NSString *mapName;
@property (readonly) NSString *backgroundMusic;

@property (readonly) NSArray *enemyCharacterDatas;
@property (readonly) NSArray *enemyBossDatas;
@property (readonly) BOOL patternRandom;
@property (readonly) NSArray *patterns;


-(id)initWithBattleName:(NSString *)name;
-(id)initWithBattleDictionary:(NSDictionary *)dic;

//-(Character *)getEnemyCastle;

@end
