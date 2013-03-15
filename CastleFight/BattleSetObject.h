//
//  BattleSetObject.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/5.
//
//

#import <Foundation/Foundation.h>

@class Character;

@interface BattleSetObject : NSObject

@property (nonatomic,readonly) NSString *sceneName;
//battle info
@property (nonatomic) NSString *mapName;
@property (nonatomic) NSArray *playerCharacterArray;
@property (nonatomic) NSArray *battleEnemyArray;
@property (nonatomic) NSArray *enemyBossArray;
@property (nonatomic) Character *playerCastle;
@property (nonatomic) Character *enemyCastle;

-(id)initWithBattleName:(NSString *)name;

@end
