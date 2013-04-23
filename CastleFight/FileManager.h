//
//  FileManager.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/14.
//
//

#import <Foundation/Foundation.h>

@class BattleDataObject,Character,AchievementManager,GameCenterManager;

@interface FileManager : NSObject

@property int userMoney;
@property AchievementManager *achievementManager;
//game center
@property (nonatomic) GameCenterManager *gameCenterManager;

+(FileManager *)sharedFileManager;

-(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName;

-(void)setGameConfig;

-(void)preloadSoundsEffect:(NSString *)sceneName;

-(void)saveUserData;

-(BattleDataObject *)loadBattleInfo:(NSString *)name;

-(NSDictionary *)getCharacterDataWithId:(NSString *)anId;
-(NSArray *)getChararcterArray;
-(Character *)getPlayerHero;
-(Character *)getPlayerCastle;

-(void)updatePlayerCharacter:(Character *)character;

-(void)switchSoundsEffect;
-(void)switchBackgroundMusic;

@end
