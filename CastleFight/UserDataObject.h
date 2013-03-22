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

@property (nonatomic, strong) NSArray *playerCharacterArray;
@property (nonatomic, strong) NSArray *playerHeroArray;
@property (nonatomic, strong) NSArray *playerCastleArray;

@property (nonatomic, strong) NSString *money;
@property (nonatomic, strong) NSArray *items;

-(id)initWithPlistPath:(NSString *)path;

-(Character *)getPlayerHero;
-(Character *)getPlayerCastle;
-(NSArray *)getPlayerCharacterArray;
-(int)getPlayerMoney;

-(void)updatePlayerMoney:(int)value;

-(void)updatePlayerCharacter:(Character *)character;

//TODO:
//-(NSArray *)getPlayerItemArray;
//-(void)updatePlayerItem;

@end
