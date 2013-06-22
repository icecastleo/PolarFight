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

@property int money;

@property (nonatomic) BOOL soundsEffectSwitch;
@property (nonatomic) BOOL backgroundMusicSwitch;
@property (nonatomic) float soundsEffectVolume;
@property (nonatomic) float backgroundMusicVolume;
@property NSArray *achievements;
@property NSArray *properties;

@property (readonly) NSArray *characterInitDatas;
@property (readonly) NSArray *playerHeroArray;
@property (readonly) NSArray *battleTeam;

-(id)initWithPlistPath:(NSString *)path;

//-(Character *)getPlayerHero;
//-(Character *)getPlayerCastle;
//-(NSArray *)getPlayerCharacterArray;

//-(void)updatePlayerCharacter:(Character *)character;

//TODO:
//-(NSArray *)getPlayerItemArray;
//-(void)updatePlayerItem;

@end
