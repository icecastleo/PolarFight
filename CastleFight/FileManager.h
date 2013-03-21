//
//  FileManager.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/14.
//
//

#import <Foundation/Foundation.h>

@class BattleDataObject,UserDataObject,Character;

@interface FileManager : NSObject

+(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName;

+(void)preloadSoundsEffect:(NSString *)sceneName;

+(void)saveUserData;
//+(UserDataObject *)getUserDataObject;

+(BattleDataObject *)loadBattleInfo:(NSString *)name;

+(NSDictionary *)getCharacterDataWithId:(NSString *)anId;
+(NSArray *)getChararcterArray;
+(Character *)getPlayerHero;
+(Character *)getPlayerCastle;
+(int)getPlayerMoney;

+(void)updatePlayerMoney:(int)value;
+(void)updatePlayerCharacterArray:(NSArray *)array;
+(void)updatePlayerHero:(Character *)hero;
+(void)updatePlayerCastle:(Character *)castle;

@end
