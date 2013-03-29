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

@property NSArray *playerCharacterArray;
@property NSArray *playerHeroArray;
@property NSArray *playerCastleArray;

@property int money;
@property NSArray *items;

@property (nonatomic) float soundsEffectVolume;
@property (nonatomic) float backgroundMusicVolume;

-(id)initWithPlistPath:(NSString *)path;

-(Character *)getPlayerHero;
-(Character *)getPlayerCastle;
-(NSArray *)getPlayerCharacterArray;

-(void)updatePlayerCharacter:(Character *)character;

//TODO:
//-(NSArray *)getPlayerItemArray;
//-(void)updatePlayerItem;

@end
