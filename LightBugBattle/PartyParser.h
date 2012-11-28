//
//  PartyParser.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/12.
//
//

#import <Foundation/Foundation.h>

@class GDataXMLDocument;

@interface PartyParser : NSObject

+ (void)saveParty;
+ (NSMutableArray *)getRolesArrayFromXMLFile;

@end
