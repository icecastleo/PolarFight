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
@property (nonatomic, readonly) NSArray *team;

@property AchievementManager *achievementManager;
//game center
@property (nonatomic) GameCenterManager *gameCenterManager;

+(FileManager *)sharedFileManager;

-(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName;

-(void)setGameConfig;

-(void)preloadSoundsEffect:(NSString *)sceneName;

-(void)saveUserData;

-(BattleDataObject *)loadBattleInfo:(NSString *)name;

-(NSDictionary *)getCharacterDataWithCid:(NSString *)cid;

//-(Character *)getPlayerHero;
//-(Character *)getPlayerCastle;
//-(void)updatePlayerCharacter:(Character *)character;

-(void)switchSoundsEffect;
-(void)switchBackgroundMusic;

@end
