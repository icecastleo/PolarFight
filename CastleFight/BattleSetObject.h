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

@property (nonatomic,readonly) NSString *battleName;
@property (nonatomic,readonly) GDataXMLDocument *characterDataFile;
@property (nonatomic,readonly) GDataXMLDocument *playerCharacterFile;
@property (nonatomic,readonly) GDataXMLDocument *battleEnemyFile;
@property (nonatomic,readonly) NSArray *allAnimations;
@property (nonatomic,readonly) NSArray *battleAnimations;

-(id)initWithBattleName:(NSString *)name;

@end
