//
//  FileManager.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/14.
//
//

#import <Foundation/Foundation.h>

@class BattleDataObject,Character,AchievementManager;

@interface FileManager : NSObject

@property int userMoney;
@property AchievementManager *achievementManager;

+(FileManager *)sharedFileManager;

-(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName;

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
