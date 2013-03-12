//
//  PartyParser.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/12.
//
//

#import <Foundation/Foundation.h>

@class GDataXMLDocument,GDataXMLElement;

@interface PartyParser : NSObject

+ (void)saveParty:(NSArray *)party fileName:(NSString *)fileName;

+ (NSString *)dataFilePath:(NSString *)fileName;

//+ (GDataXMLElement *)getNodeFromXmlFile:(NSString *)fileName tagName:(NSString *)tagName tagId:(NSString *)tagId;

+ (GDataXMLDocument *)loadGDataXMLDocumentFromFileName:(NSString *)fileName;

+ (GDataXMLElement *)getNodeFromXmlFile:(GDataXMLDocument *)doc tagName:(NSString *)tagName tagAttributeName:(NSString *)tagAttributeName tagAttributeValue:(NSString *)tagAttributeValue;

+ (NSArray *)getAllNodeFromXmlFile:(GDataXMLDocument *)doc tagName:(NSString *)tagName;

+ (NSArray *)getAllFilePathsInDirectory:(NSString *)directoryName fileType:(NSString *)type;
+ (NSArray *)getAllFilePathsInDirectory:(NSString *)directoryName withPrefix:(NSString *)prefix fileType:(NSString *)type;

+ (NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName;

@end
