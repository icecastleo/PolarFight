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

//+ (GDataXMLElement *)getNodeFromXmlFile:(NSString *)fileName tagName:(NSString *)tagName tagId:(NSString *)tagId;
+ (GDataXMLElement *)getNodeFromXmlFile:(NSString *)fileName tagName:(NSString *)tagName tagAttributeName:(NSString *)tagAttributeName tagAttributeValue:(NSString *)tagAttributeValue;

+ (NSArray *)getAllNodeFromXmlFile:(NSString *)fileName tagName:(NSString *)tagName tagAttributeName:(NSString *)tagAttributeName;

+ (NSArray *)getAllAimationPlistFromCharacterName:(NSString *)name;
+ (NSArray *)getAllSoundsPlistFromCharacterName:(NSString *)name;

@end
