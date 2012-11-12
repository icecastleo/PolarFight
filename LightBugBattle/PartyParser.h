//
//  PartyParser.h
//  LightBugBattle
//
//  Created by  DAN on 12/11/12.
//
//

#import <Foundation/Foundation.h>

@class Party;

@interface PartyParser : NSObject

+ (Party *)loadParty;
+ (void)saveParty:(Party *)party;

@end
