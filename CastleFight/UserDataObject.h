//
//  UserDataObject.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import <Foundation/Foundation.h>

@class Character;

@interface UserDataObject : NSObject <NSCoding>

@property (strong) NSArray *playerCharacterArray;
@property (strong) NSArray *playerHeroArray;
@property (strong) NSArray *playerCastleArray;

@property (strong) NSString *money;
@property (strong) NSArray *items;

-(id)initWithPlistPath:(NSString *)path;

-(Character *)getPlayerHero;
-(Character *)getPlayerCastle;
-(NSArray *)getPlayerCharacterArray;


@end
