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

#define kUserDataKey        @"UserData"

@interface FileManager ()

@property (nonatomic,strong) NSDictionary *animationDictionary;
@property (nonatomic,readonly) NSArray *characterDataFile;
@property (nonatomic,strong) NSArray *sceneSounds;
@property (nonatomic, strong) UserDataObject *userDataObject;

@end

@implementation FileManager

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
	@synchronized(self)     {
		NSAssert(sharedFileManager == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
	return nil;
}

- (UserDataObject *)loadUserDataObject {
    
    if (_userDataObject != nil) return _userDataObject;
    //When someone tries to access the data property, we’re going to check if we have it loaded into memory – and if so go ahead and return it. But if not, we’ll load it from disk!
    
    //get File in Documents
    NSString *dataPath = [FileManager dataFilePath:@"UserData.plist" forSave:YES];
    NSData *codedData = [[NSData alloc] initWithContentsOfFile:dataPath];
    
    if (!codedData) {
        //get file in bundle
        dataPath = [FileManager dataFilePath:@"UserData.plist" forSave:NO];
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
    NSArray *allAnimations = [FileManager getAllFilePathsInDirectory:@"Animation" fileType:@"plist"];
    
    for (NSString *path in allAnimations) {
        NSArray *fileArray = [path componentsSeparatedByString:@"/"];
        NSString *fileName = [fileArray lastObject];
        
        NSDictionary *clip = [AKHelpers animationClipFromPlist:path];
        [tempDicionary setValue:clip forKey:fileName];
    }
    return tempDicionary;
}

+ (NSArray *)loadPlistFromFileName:(NSString *)fileName {
    
    NSString *filePath = [self dataFilePath:fileName forSave:NO];
    
    // characterBasicData and BattleData are array.
    NSArray *plist = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    return plist;
}

-(id)init {
	if((self=[super init])) {
        _userDataObject =  [self loadUserDataObject];
//        _animationDictionary = [self loadAnimation];
        _characterDataFile = [FileManager loadPlistFromFileName:@"CharacterBasicData.plist"];
	}
	return self;
}

// Memory
-(void)dealloc {
    _userDataObject = nil;
    _animationDictionary = nil;
    _characterDataFile = nil;
}

+(void)end {
	sharedFileManager = nil;
}

+ (NSString *)dataFilePath:(NSString *)fileName forSave:(BOOL)save {
    if (!fileName)
    {
        fileName = @"Default.xml";
    }
    
    //the app directory path not bundle //bundle is readonly
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

+ (NSArray *)getAllFilePathsInDirectory:(NSString *)directoryName fileType:(NSString *)type {
    // you can put path in directoryName ex: test/test2
    NSArray *directoryAndFileNames = [[NSBundle mainBundle] pathsForResourcesOfType:type inDirectory:directoryName];
    
    return directoryAndFileNames;
}

+ (NSArray *)getAllFilePathsInDirectory:(NSString *)directoryName withPrefix:(NSString *)prefix fileType:(NSString *)type {
    
    NSArray *directoryAndFileNames = [[NSBundle mainBundle] pathsForResourcesOfType:type inDirectory:directoryName];
    
    NSMutableArray *targetFileNameArray = [NSMutableArray array];
    
    for (NSString *path in directoryAndFileNames) {
        NSArray *fileArray = [path componentsSeparatedByString:@"/"];
        NSString *fileName = [fileArray lastObject];
        if ([fileName hasPrefix:prefix]) {
            //NSLog(@"targetFile:%@",fileName);
            [targetFileNameArray addObject:path];
        }
    }
    
    return targetFileNameArray;
}

+(NSDictionary *)getDictionaryInArray:(NSArray *)anArray WithTagName:(NSString *)tagName tagValue:(NSString *)tagValue {
    for (NSDictionary *dic in anArray) {
        if ([tagValue isEqualToString:[dic objectForKey:tagName]]) {
            return dic;
        }
    }
    return nil;
}

-(void)updateUserDataObject {
    _userDataObject = nil;
    _userDataObject = [self loadUserDataObject];
}

- (void)saveUserData {
    
    if (_userDataObject == nil) return;
    
    NSString *dataPath = [FileManager dataFilePath:@"UserData.plist" forSave:YES];
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:_userDataObject forKey:kUserDataKey];
    [archiver finishEncoding];
    [data writeToFile:dataPath atomically:YES];
    NSLog(@"Saving xml data to %@...", dataPath);
    
    [self updateUserDataObject];
}

#pragma mark Testing
//FIXME: save plist file
/*
+(void)testSave:(NSArray *)characterArray {
    
    NSMutableArray *books = [NSMutableArray new];
    
    for (Character *character in characterArray) {
        NSMutableDictionary *book = [NSMutableDictionary new];
        
        NSString *levelString = [NSString stringWithFormat:@"%d",character.level];
        [book setObject:character.characterId forKey:@"id"];
        [book setObject:levelString forKey:@"level"];
        
        [books addObject:book];
    }
    
    //serialization Binary
    NSString *filePath = [self dataFilePath:@"SelectedCharacters.plist" forSave:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    NSString *error;
    NSData *xmlData = [NSPropertyListSerialization dataFromPropertyList:books format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
    
    if(xmlData)
    {
        NSLog(@"No error creating XML data.");
        [xmlData writeToFile:filePath atomically:YES];
    }
    else
    {
        NSLog(@"%@",error);
    }
}
//*/

+(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName {
    // ex: animationName = Animation_Swordsman_walking_Down.plist
    return [[self sharedFileManager].animationDictionary objectForKey:animationName];
}

+(void)unloadSoundsEffect {
    for (NSString *fileName in [self sharedFileManager].sceneSounds) {
        [[SimpleAudioEngine sharedEngine] unloadEffect:fileName];
    }
    [self sharedFileManager].sceneSounds = nil;
}

+(void)preloadSoundsEffect:(NSString *)sceneName {
    
    if ([self sharedFileManager].sceneSounds) {
        [self unloadSoundsEffect];
    }
    
    NSString *path = [NSString stringWithFormat:@"Sounds_caf/%@",sceneName];
    
    [self sharedFileManager].sceneSounds = [self getAllFilePathsInDirectory:path fileType:@"caf"];
    for (NSString *fileName in [self sharedFileManager].sceneSounds) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:fileName];
    }
    
}

+(void)saveUserData {
    [[self sharedFileManager] saveUserData];
}

+ (UserDataObject *)getUserDataObject {
    return [self sharedFileManager].userDataObject;
}

+(NSDictionary *)getCharacterDataWithId:(NSString *)anId {
    return [self getDictionaryInArray:[self sharedFileManager].characterDataFile WithTagName:@"id" tagValue:anId];
}

+ (NSArray *)getChararcterArray {
    return [[self sharedFileManager].userDataObject getPlayerCharacterArray];
}

+ (Character *)getPlayerHero {
    return [[self sharedFileManager].userDataObject getPlayerHero];
}

+ (Character *)getPlayerCastle {
    return [[self sharedFileManager].userDataObject getPlayerCastle];
}

+(BattleDataObject *)loadBattleInfo:(NSString *)name {
    NSArray *allBattleDataArray = [FileManager loadPlistFromFileName:@"BattleData.plist"];
    for (NSDictionary *dic in allBattleDataArray) {
        if ([name isEqualToString:[dic objectForKey:@"name"]]) {
            BattleDataObject *battleDataObject = [[BattleDataObject alloc] initWithBattleDictionary:dic];
            return battleDataObject;
        }
    }
    return nil;
}

#pragma mark not done
//FIXME: not done
-(void)playBackgroundMusic:(NSString *)name {
    
    //FIXME: No BackgroundMusic_caf Folder
    NSArray *music = [FileManager getAllFilePathsInDirectory:@"BackgroundMusic_caf" withPrefix:name fileType:@"caf"];
    
    NSString *fileName = [music lastObject];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:fileName];
}
/*
 +(void)loadSceneInfo:(NSString *)name {
 GDataXMLDocument *battleInfoDoc = [self loadGDataXMLDocumentFromFileName:@"BattleData.xml"];
 GDataXMLElement *characterElement = [FileManager getNodeFromXmlFile:battleInfoDoc tagName:@"menu" tagAttributeName:@"name" tagAttributeValue:name];
 
 
 NSString *backgroundMusicName;
 
 //get tag's attributes
 for (GDataXMLNode *attribute in characterElement.attributes) {
 if([attribute.name isEqualToString:@"bgm"]) {
 backgroundMusicName = attribute.stringValue;
 }
 }
 }
 //*/
@end
