//
//  FileManager.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/14.
//
//

#import <Foundation/Foundation.h>

@class BattleDataObject, AchievementManager, GameCenterManager;

@interface FileManager : NSObject

@property int userMoney;
@property (readonly) NSArray *characterInitDatas;
@property (nonatomic, readonly) NSArray *battleTeam;
@property (nonatomic, readonly) NSArray *magicTeam;
@property (nonatomic, readonly) NSArray *magicInBattle;
@property (nonatomic, readonly) NSArray *items;
@property (nonatomic, readonly) NSArray *itemsInBattle;
@property (nonatomic, readonly) NSArray *orbSkills;

@property AchievementManager *achievementManager;
//game center
@property (nonatomic) GameCenterManager *gameCenterManager;

+(FileManager *)sharedFileManager;

-(void)setGameConfig;
-(void)switchSoundsEffect;
-(void)switchBackgroundMusic;

-(void)preloadSoundsEffect:(NSString *)sceneName;
-(void)saveUserData;

-(BattleDataObject *)loadBattleInfo:(NSString *)name;

-(NSDictionary *)getCharacterDataWithCid:(NSString *)cid;

-(NSDictionary *)getPatternDataWithPid:(NSString *)pid;

//-(Character *)getPlayerHero;
//-(Character *)getPlayerCastle;

@end
