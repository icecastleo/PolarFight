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

@property NSArray *achievements;
@property NSArray *properties;

@property (readonly) NSArray *characterInitDatas;
@property (readonly) NSArray *playerHeroArray;
@property (readonly) NSArray *battleTeam;
@property (readonly) NSArray *magicTeam;

-(id)initWithPlistPath:(NSString *)path;

//-(Character *)getPlayerHero;
//-(Character *)getPlayerCastle;

//TODO:
//-(NSArray *)getPlayerItemArray;
//-(void)updatePlayerItem;

@end
