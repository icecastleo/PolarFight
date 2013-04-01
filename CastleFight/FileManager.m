//
//  FileManager.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/14.
//
//

#import "FileManager.h"
#import "Character.h"
#import "AKHelpers.h"
#import "SimpleAudioEngine.h"
#import "BattleDataObject.h"
#import "UserDataObject.h"
#import "AchievementManager.h"

@interface FileManager ()

@property (nonatomic, strong) NSDictionary *animationDictionary;
@property (nonatomic, readonly) NSDictionary *characterDataFile;
@property (nonatomic, strong) NSArray *sceneSounds;
@property (nonatomic, strong) UserDataObject *userDataObject;

@end

@implementation FileManager

#define kUserDataKey @"UserData"

#define kAnimationDirectory @"Animation"
#define kSoundsDirectory @"Sounds_caf"

#define kUserDataPlistFileName @"UserData.plist"
#define kCharacterDataPlistFileName @"CharacterBasicData.plist"
#define kBattleDataPlistFileName @"BattleData.plist"

#define kBattleDataTagKey @"id"
#define kCharacterDataTagKey @"id"

#define kVolumeMute 0
#define kVolumeBackgroundMusicDefault 0.05
#define kVolumeEffectDefault 0.5

@dynamic userMoney;

static FileManager *sharedFileManager = nil;

// Init
+(FileManager *)sharedFileManager {
	@synchronized(self)     {
		if (!sharedFileManager)
			sharedFileManager = [[FileManager alloc] init];
	}
	return sharedFileManager;
}

+(id)alloc {
	@synchronized(self) {
		NSAssert(sharedFileManager == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
	return nil;
}

- (UserDataObject *)loadUserDataObject {
    
    if (_userDataObject != nil) return _userDataObject;
    //When someone tries to access the data property, we’re going to check if we have it loaded into memory – and if so go ahead and return it. But if not, we’ll load it from disk!
    
    //get File in Documents
    NSString *dataPath = [self dataFilePath:kUserDataPlistFileName forSave:YES];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    
    if (!codedData) {
        //get file in bundle
        dataPath = [self dataFilePath:kUserDataPlistFileName forSave:NO];
        _userDataObject = [[UserDataObject alloc] initWithPlistPath:dataPath];
    }else {
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:codedData];
        
        _userDataObject = [unarchiver decodeObjectForKey:kUserDataKey];
        [unarchiver finishDecoding];
    }
    
    return _userDataObject;
}

-(NSDictionary *)loadAnimation {
    NSMutableDictionary *tempDicionary = [NSMutableDictionary dictionary];
    NSArray *allAnimations = [self getAllFilePathsInDirectory:kAnimationDirectory fileType:@"plist"];
    
    for (NSString *path in allAnimations) {
        NSArray *fileArray = [path componentsSeparatedByString:@"/"];
        NSString *fileName = [fileArray lastObject];
        
        NSDictionary *clip = [AKHelpers animationClipFromPlist:path];
        [tempDicionary setValue:clip forKey:fileName];
    }
    return tempDicionary;
}

-(void)setGameConfig {
    if (self.userDataObject.soundsEffectSwitch) {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:self.userDataObject.soundsEffectVolume];
    } else
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:kVolumeMute];
    
    if (self.userDataObject.backgroundMusicSwitch) {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:self.userDataObject.backgroundMusicVolume];
    } else
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:kVolumeMute];
    
}

- (NSDictionary *)getDictionaryFromPlistFileName:(NSString *)fileName {
    
    NSString *path = [self dataFilePath:fileName forSave:NO];
    NSDictionary *plistDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    
    return plistDic;
}

- (NSDictionary *)getDictionaryFromPlistDictionary:(NSDictionary *)plistDic tagName:(NSString *)tagName tagValue:(NSString *)tagValue {
    
    for (NSString *key in plistDic) {
        id object = [plistDic objectForKey:key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            if ([tagValue isEqualToString:[object objectForKey:tagName]]) {
                return object;
            }
        }
    }
    
    return nil;
}

-(id)init {
	if((self=[super init])) {
        _userDataObject =  [self loadUserDataObject];
//        _animationDictionary = [self loadAnimation]; //do not use temporary
        _characterDataFile = [self getDictionaryFromPlistFileName:kCharacterDataPlistFileName];
        _achievementManager = [[AchievementManager alloc] initWithAchievements:self.userDataObject.achievements AndProperties:self.userDataObject.properties];
        [self setGameConfig];
	}
	return self;
}

// Memory
-(void)dealloc {
    _userDataObject = nil;
    _animationDictionary = nil;
    _characterDataFile = nil;
}

-(void)setUserMoney:(int)userMoney {
    _userDataObject.money = userMoney;
}

-(int)userMoney {
    return _userDataObject.money;
}

+(void)end {
	sharedFileManager = nil;
}

- (NSString *)dataFilePath:(NSString *)fileName forSave:(BOOL)save {
    if (!fileName)
    {
        fileName = @"Default.xml";
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSArray *fileArray = [fileName componentsSeparatedByString:@"."];
    NSString *fname = [fileArray objectAtIndex:0];
    NSString *ftype = [fileArray lastObject];
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:fileName];
    if (save ||
        [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) {
        return documentsPath;
    } else {
        return [[NSBundle mainBundle] pathForResource:fname ofType:ftype];
    }
}

-(NSArray *)getAllFilePathsInDirectory:(NSString *)directoryName fileType:(NSString *)type {
    // you can put path in directoryName ex: test/test2
    NSArray *directoryAndFileNames = [[NSBundle mainBundle] pathsForResourcesOfType:type inDirectory:directoryName];
    
    return directoryAndFileNames;
}

- (NSArray *)getAllFilePathsInDirectory:(NSString *)directoryName withPrefix:(NSString *)prefix fileType:(NSString *)type {
    
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
    
    if (_userDataObject == nil) return;
    
    NSString *dataPath = [self dataFilePath:kUserDataPlistFileName forSave:YES];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_userDataObject forKey:kUserDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    NSLog(@"Saving xml data to %@...", dataPath);
}

#pragma mark Public Functions

-(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName {
    // ex: animationName = Animation_Swordsman_walking_Down.plist
    return [self.animationDictionary objectForKey:animationName];
}

-(void)unloadSoundsEffect {
    for (NSString *fileName in self.sceneSounds) {
        [[SimpleAudioEngine sharedEngine] unloadEffect:fileName];
    }
    self.sceneSounds = nil;
}

-(void)preloadSoundsEffect:(NSString *)sceneName {
    
    if (self.sceneSounds) {
        [self unloadSoundsEffect];
    }
    
    NSString *path = [kSoundsDirectory stringByAppendingFormat:@"/%@",sceneName];
    
    self.sceneSounds = [self getAllFilePathsInDirectory:path fileType:@"caf"];
    for (NSString *fileName in self.sceneSounds) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:fileName];
    }
    
}

-(BattleDataObject *)loadBattleInfo:(NSString *)name {
    
    NSDictionary *plistDic = [self getDictionaryFromPlistFileName:kBattleDataPlistFileName];
    
    NSDictionary *battleDic = [self getDictionaryFromPlistDictionary:plistDic tagName:kBattleDataTagKey tagValue:name];
    
    BattleDataObject *battleDataObject = [[BattleDataObject alloc] initWithBattleDictionary:battleDic];
        
    return battleDataObject;
}

-(NSDictionary *)getCharacterDataWithId:(NSString *)anId {
    return  [self getDictionaryFromPlistDictionary:self.characterDataFile tagName:kCharacterDataTagKey tagValue:anId];
}

-(NSArray *)getChararcterArray {
    return [self.userDataObject getPlayerCharacterArray];
}

-(Character *)getPlayerHero {
    return [self.userDataObject getPlayerHero];
}

-(Character *)getPlayerCastle {
    return [self.userDataObject getPlayerCastle];
}

-(void)updatePlayerCharacter:(Character *)character {
    [self.userDataObject updatePlayerCharacter:character];
}

-(void)switchSoundsEffect {
    if ([SimpleAudioEngine sharedEngine].effectsVolume != kVolumeMute) {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:kVolumeMute];
        self.userDataObject.soundsEffectVolume = kVolumeMute;
        self.userDataObject.soundsEffectSwitch = FALSE;
    }else {
        [[SimpleAudioEngine sharedEngine] setEffectsVolume:kVolumeEffectDefault];
        self.userDataObject.soundsEffectVolume = kVolumeEffectDefault;
        self.userDataObject.soundsEffectSwitch = TRUE;
    }
//    [self saveUserData];
}

-(void)switchBackgroundMusic {
    if ([SimpleAudioEngine sharedEngine].backgroundMusicVolume != kVolumeMute) {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:kVolumeMute];
        self.userDataObject.backgroundMusicVolume = kVolumeMute;
        self.userDataObject.backgroundMusicSwitch = FALSE;
    }else {
        [[SimpleAudioEngine sharedEngine] setBackgroundMusicVolume:kVolumeBackgroundMusicDefault];
        self.userDataObject.backgroundMusicVolume = kVolumeBackgroundMusicDefault;
        self.userDataObject.backgroundMusicSwitch = TRUE;
    }
//    [self saveUserData];
}

@end
