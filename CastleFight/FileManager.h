//
//  FileManager.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/14.
//
//

#import <Foundation/Foundation.h>

@class GDataXMLDocument,GDataXMLElement,BattleDataObject;

@interface FileManager : NSObject

+ (GDataXMLElement *)getNodeFromXmlFile:(GDataXMLDocument *)doc tagName:(NSString *)tagName tagAttributeName:(NSString *)tagAttributeName tagAttributeValue:(NSString *)tagAttributeValue;
+ (NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName;

+ (NSArray *)getChararcterArray;
+ (void)saveCharacterArray:(NSArray *)characterArray;
+ (GDataXMLDocument *)getCharacterBasicData;
+(void)preloadSoundsEffect:(NSString *)sceneName;

+(BattleDataObject *)loadBattleInfo:(NSString *)name;

@end
