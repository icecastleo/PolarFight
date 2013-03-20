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

+ (NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName;

+(void)preloadSoundsEffect:(NSString *)sceneName;

+ (void)saveUserData;
+ (UserDataObject *)getUserDataObject;

+(NSDictionary *)getCharacterDataWithId:(NSString *)anId;
+ (NSArray *)getChararcterArray;
+ (Character *)getPlayerHero;
+ (Character *)getPlayerCastle;

+(BattleDataObject *)loadBattleInfo:(NSString *)name;

@end
