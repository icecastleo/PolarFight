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
@property (nonatomic,strong) NSString *mapName;
@property (nonatomic,strong) NSString *backgroundMusic;

//@property (nonatomic) NSArray *playerCharacterArray;

@property (nonatomic,strong) NSArray *enemyArray;
@property (nonatomic,strong) NSArray *enemyBossArray;
@property (nonatomic,strong) NSArray *enemyCastleArray;

//@property (nonatomic) Character *playerCastle;
//@property (nonatomic) Character *enemyCastle;

-(id)initWithBattleName:(NSString *)name;

-(id)initWithBattleDictionary:(NSDictionary *)dic;

-(NSArray *)getEnemyBoss;
-(Character *)getEnemyCastle;
-(NSArray *)getEnemyArray;

@end
