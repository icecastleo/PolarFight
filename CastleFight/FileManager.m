//
//  FileManager.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/14.
//
//

#import "FileManager.h"
#import "SimpleAudioEngine.h"
#import "BattleDataObject.h"
#import "UserDataObject.h"
#import "AchievementManager.h"
#import "GameCenterManager.h"

#define kSoundsDirectory @"Sounds_caf"

#define kUserDataFile @"UserData.plist"
#define kCharacterDatasFile @"CharacterBasicData.plist"
#define kMapDatasFile @"BattleData.plist"
#define kPatternDataFile @"OrbPattern.plist"

#define kUserDataArchiveKey @"UserData"

#define kBattleDataTag @"id"

@interface FileManager () {
    NSDictionary *characterDatas;
    NSDictionary *patterns;
    NSArray *sceneSounds;
    UserDataObject *userData;
}
@end

@implementation FileManager

@dynamic userMoney;
@dynamic characterInitDatas;

+(FileManager *)sharedFileManager {
	static dispatch_once_t onceToken;
    static FileManager *sharedManager = nil;
    
    dispatch_once(&onceToken, ^{
        sharedManager = [[FileManager alloc] init];
    });
                  
    return sharedManager;
}

-(id)init {
	if((self = [super init])) {
        userData = [self loadUserData];
        characterDatas = [self getDictionaryFromPlistFile:kCharacterDatasFile];
        patterns = [self getDictionaryFromPlistFile:kPatternDataFile];
        
        NSMutableArray *achievements = [NSMutableArray arrayWithArray:userData.achievements];
        NSMutableArray *properties = [NSMutableArray arrayWithArray:userData.properties];
        [achievements addObjectsFromArray:userData.orbSkills];
        [achievements addObjectsFromArray:userData.magicTeam];
        [properties addObjectsFromArray:userData.magicProperties];
        [properties addObjectsFromArray:userData.orbSkillProperties];
        
        _achievementManager = [[AchievementManager alloc] initWithAchievements:achievements AndProperties:properties];
        
        // game center
        self.gameCenterManager = [[GameCenterManager alloc] init];
        [self.gameCenterManager authenticateLocalPlayer];
	}
	return self;
}

-(UserDataObject *)loadUserData {
    // Get save file in Documents
    NSString *dataPath = [self filePath:kUserDataFile forSave:YES];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    
    if (!codedData) {
        // Get default plist in bundle
        dataPath = [self filePath:kUserDataFile forSave:NO];
        userData = [[UserDataObject alloc] initWithPlistPath:dataPath];
    } else {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
        userData = [unarchiver decodeObjectForKey:kUserDataArchiveKey];
        [unarchiver finishDecoding];
    }
    
    return userData;
}

-(void)setGameConfig {
    if (userData.soundsEffectSwitch) {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:userData.soundsEffectVolume];
    } else {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0];
    }
    
    if (userData.backgroundMusicSwitch) {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:userData.backgroundMusicVolume];
    } else {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
    }
}

-(void)switchBackgroundMusic {
    if (userData.backgroundMusicSwitch) {
        userData.backgroundMusicSwitch = NO;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:0];
    } else {
        userData.backgroundMusicSwitch = YES;
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:userData.backgroundMusicVolume];
    }
    //    [self saveUserData];
}

-(void)switchSoundsEffect {
    if (userData.soundsEffectSwitch) {
        userData.soundsEffectSwitch = NO;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:0];
    } else {
        userData.soundsEffectSwitch = YES;
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:userData.soundsEffectVolume];
    }
    //    [self saveUserData];
}

-(void)setUserMoney:(int)userMoney {
    userData.money = userMoney;
}

-(int)userMoney {
    return userData.money;
}


-(NSDictionary *)getDictionaryFromPlistFile:(NSString *)fileName {
    NSString *path = [self filePath:fileName forSave:NO];
    
    return [[NSDictionary alloc] initWithContentsOfFile:path];
}

- (NSString *)filePath:(NSString *)fileName forSave:(BOOL)save {
    NSAssert(fileName, @"What do you want with a nil parameter?");
    
    if (save) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:fileName];
        
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:[fileName stringByDeletingPathExtension] ofType:[fileName pathExtension]];
    }
}

//-(NSDictionary *)getDictionaryFromPlistDictionary:(NSDictionary *)plistDic tagName:(NSString *)tagName tagValue:(NSString *)tagValue {
//    for (NSString *key in plistDic) {
//        id object = [plistDic objectForKey:key];
//        if ([object isKindOfClass:[NSDictionary class]]) {
//            if ([tagValue isEqualToString:[object objectForKey:tagName]]) {
//                return object;
//            }
//        }
//    }
//    return nil;
//}

-(NSArray *)getAllFilePathsInDirectory:(NSString *)directoryName fileType:(NSString *)type {
    // you can put path in directoryName ex: test/test2
    NSArray *directoryAndFileNames = [[NSBundle mainBundle] pathsForResourcesOfType:type inDirectory:directoryName];
    
    return directoryAndFileNames;
}

-(NSArray *)getAllFilePathsInDirectory:(NSString *)directoryName withPrefix:(NSString *)prefix fileType:(NSString *)type {
    
    NSArray *directoryAndFileNames = [[NSBundle mainBundle] pathsForResourcesOfType:type inDirectory:directoryName];
    
    NSMutableArray *targetFileNameArray = [NSMutableArray array];
    
    for (NSString *path in directoryAndFileNames) {
        NSArray *fileArray = [path componentsSeparatedByString:@"/"];
        NSString *fileName = [fileArray lastObject];
        if ([fileName hasPrefix:prefix]) {
            [targetFileNameArray addObject:path];
        }
    }
    
    return targetFileNameArray;
}

-(void)saveUserData {
    NSString *dataPath = [self filePath:kUserDataFile forSave:YES];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:userData forKey:kUserDataArchiveKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    
    CCLOG(@"Saving xml data to %@...", dataPath);
}

-(void)preloadSoundsEffect:(NSString *)sceneName {
    if (sceneSounds) {
        [self unloadSoundsEffect];
    }
    
    NSString *path = [kSoundsDirectory stringByAppendingFormat:@"/%@",sceneName];
    
    sceneSounds = [self getAllFilePathsInDirectory:path fileType:@"caf"];
    
    for (NSString *fileName in sceneSounds) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:fileName];
    }
}

-(void)unloadSoundsEffect {
    for (NSString *fileName in sceneSounds) {
        [[SimpleAudioEngine sharedEngine] unloadEffect:fileName];
    }
    sceneSounds = nil;
}

-(BattleDataObject *)loadBattleInfo:(NSString *)name {
    NSDictionary *plistDic = [self getDictionaryFromPlistFile:kMapDatasFile];
    NSDictionary *battleDic = [plistDic objectForKey:name];
    
    NSAssert(battleDic != nil, @"Loading battle %@'s data failed.", name);
    
    BattleDataObject *battleDataObject = [[BattleDataObject alloc] initWithBattleDictionary:battleDic];
        
    return battleDataObject;
}

-(NSDictionary *)getCharacterDataWithCid:(NSString *)cid {
    return characterDatas[cid];
}

-(NSDictionary *)getPatternDataWithPid:(NSString *)pid {
    return patterns[pid];
}

-(NSArray *)characterInitDatas {
    return userData.characterInitDatas;
}

-(NSArray *)battleTeam {
    return userData.battleTeam;
}

-(NSArray *)magicTeam {
    return userData.magicTeam;
}

-(NSArray *)magicInBattle {
    return userData.magicInBattle;
}

-(NSArray *)orbSkills {
    return userData.orbSkills;
}

-(NSArray *)items {
    return userData.items;
}

-(NSArray *)itemsInBattle {
    return userData.itemsInBattle;
}

//-(Character *)getPlayerHero {
//    return [self.userDataObject getPlayerHero];
//}
//
//-(Character *)getPlayerCastle {
//    return [self.userDataObject getPlayerCastle];
//}

@end
