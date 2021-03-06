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

@property (nonatomic) BOOL backgroundMusicSwitch;
@property (nonatomic) BOOL soundsEffectSwitch;
@property (nonatomic) float backgroundMusicVolume;
@property (nonatomic) float soundsEffectVolume;

@property (nonatomic) NSArray *achievements;
@property (nonatomic) NSArray *properties;
@property (nonatomic) NSArray *orbSkills;
@property (nonatomic) NSArray *orbSkillProperties;
@property (nonatomic) NSArray *magicProperties;

@property (readonly) NSArray *characterInitDatas;
@property (readonly) NSArray *playerHeroArray;
@property (readonly) NSArray *battleTeam;
@property (readonly) NSArray *magicTeam;
@property (readonly) NSArray *magicInBattle;
@property (readonly) NSArray *items;
@property (readonly) NSArray *itemsInBattle;

-(id)initWithPlistPath:(NSString *)path;

//-(Character *)getPlayerHero;
//-(Character *)getPlayerCastle;

//TODO:
//-(NSArray *)getPlayerItemArray;
//-(void)updatePlayerItem;

@end
