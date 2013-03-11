//
//  BattleSetObject.h
//  CastleFight
//
//  Created by  DAN on 13/3/5.
//
//

#import <Foundation/Foundation.h>

@class GDataXMLDocument,GDataXMLElement;

@interface BattleSetObject : NSObject

@property (nonatomic,readonly) NSString *sceneName;
@property (nonatomic,readonly) GDataXMLDocument *characterDataFile;
@property (nonatomic,readonly) GDataXMLDocument *allCharacterFile;
@property (nonatomic,readonly) GDataXMLDocument *playerCharacterFile;
@property (nonatomic,readonly) GDataXMLDocument *battleEnemyFile;

-(id)initWithBattleName:(NSString *)name;

@end
