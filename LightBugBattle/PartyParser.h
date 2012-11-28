//
//  PartyParser.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/12.
//
//

#import <Foundation/Foundation.h>

@class Party, GDataXMLDocument;

@interface PartyParser : NSObject
{
    GDataXMLDocument *_doc;
}

@property (readonly) GDataXMLDocument *doc;

+ (Party *)loadParty;
+ (void)saveParty:(Party *)party;



//- (NSDictionary *)attributesForNode:(NSString *)nodeName;
+ (id) initWithXmlFile:(NSString *) fileName;
@end
