//
//  BattleSetObject.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/5.
//
//

#import <Foundation/Foundation.h>

@class GDataXMLDocument,GDataXMLElement;

@interface BattleSetObject : NSObject

@property (nonatomic,readonly) NSString *sceneName;
//battle info
@property (nonatomic,readonly) NSString *mapName;
@property (nonatomic,readonly) GDataXMLDocument *characterDataFile;
@property (nonatomic,readonly) NSArray *battleEnemyArray;
@property (nonatomic,readonly) NSArray *enemyBossArray;
@property (nonatomic,readonly) GDataXMLElement *enemyCastle;

-(id)initWithBattleName:(NSString *)name;

@end
