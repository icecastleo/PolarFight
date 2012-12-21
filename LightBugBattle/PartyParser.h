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

+ (void)saveParty;

+ (GDataXMLElement *)getNodeFromXmlFile:(NSString *)fileName TagName:(NSString *)tagName tagId:(NSString *)tagId;

@end
