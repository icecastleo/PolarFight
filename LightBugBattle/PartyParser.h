//
//  PartyParser.h
//  LightBugBattle
//
//  Created by  浩翔 on 12/11/12.
//
//

#import <Foundation/Foundation.h>

@class Party;

@interface PartyParser : NSObject

+ (Party *)loadPartyFromType:(int)type withPlayer:(int)player;
+ (void)saveParty:(Party *)party;

@end
