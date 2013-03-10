//
//  BattleSetObject.h
//  CastleFight
//
//  Created by  DAN on 13/3/5.
//
//

#import <Foundation/Foundation.h>

@class GDataXMLDocument,GDataXMLElement,CCSpriteBatchNode;

@interface BattleSetObject : NSObject

@property (nonatomic,readonly) NSString *battleName;
@property (nonatomic,readonly) GDataXMLDocument *characterDataFile;
@property (nonatomic,readonly) GDataXMLDocument *allCharacterFile;
@property (nonatomic,readonly) GDataXMLDocument *playerCharacterFile;
@property (nonatomic,readonly) GDataXMLDocument *battleEnemyFile;
@property (nonatomic,readonly) NSMutableDictionary *animationDictionary;
@property (nonatomic,readonly) NSDictionary *battleAnimations;

-(id)initWithBattleName:(NSString *)name;
-(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName;

@end
