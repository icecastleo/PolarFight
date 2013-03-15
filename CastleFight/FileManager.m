//
//  FileManager.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/14.
//
//

#import "FileManager.h"
#import "GDataXMLNode.h"
#import "Character.h"
#import "XmlParser.h"
#import "AKHelpers.h"
#import "SimpleAudioEngine.h"
#import "BattleSetObject.h"

@interface FileManager () {
    GDataXMLDocument *allCharacterDoc;
}
@property (nonatomic) NSArray *characterElements;
@property (nonatomic) NSMutableDictionary *animationDictionary;
@property (nonatomic,readonly) GDataXMLDocument *characterDataFile;
@property (nonatomic) NSArray *sceneSounds;

@end

@implementation FileManager

static FileManager *sharedFileManager = nil;

// Init
+(FileManager *)sharedFileManager
{
	@synchronized(self)     {
		if (!sharedFileManager)
			sharedFileManager = [[FileManager alloc] init];
	}
	return sharedFileManager;
}

+(id)alloc
{
	@synchronized(self)     {
		NSAssert(sharedFileManager == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
	return nil;
}

-(id)init
{
	if((self=[super init])) {
        _characterElements = [FileManager getAllNodeFromXmlFile:[FileManager loadGDataXMLDocumentFromFileName:@"SelectedCharacters.xml"] tagName:@"character"];
        _characterDataFile = [FileManager loadGDataXMLDocumentFromFileName:@"CharacterData.xml"];
	}
	return self;
}

// Memory
-(void)dealloc
{
    self.characterElements = nil;
    self.animationDictionary = nil;
}

+(void)end
{
	sharedFileManager = nil;
}

+ (NSString *)dataFilePath:(NSString *)fileName forSave:(BOOL)save
{
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

//in Disk. load slowly.
+ (GDataXMLDocument *)loadGDataXMLDocumentFromFileName:(NSString *)fileName {
    NSString *filePath = [self dataFilePath:fileName forSave:NO];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData
                                                           options:0 error:&error];
    return doc;
}

+ (GDataXMLElement *)getNodeFromXmlFile:(GDataXMLDocument *)doc tagName:(NSString *)tagName tagAttributeName:(NSString *)tagAttributeName tagAttributeValue:(NSString *)tagAttributeValue
{
    
    if (doc == nil) { return nil; }
    
    NSString *xPath = [[NSString alloc] initWithFormat:@"//%@",tagName];
    NSArray *elements = [doc nodesForXPath:xPath error:nil];
    
    for (GDataXMLElement *element in elements) {
        for (GDataXMLNode *attribute in element.attributes) {
            if ([attribute.name isEqualToString:tagAttributeName]) {
                if ([attribute.stringValue isEqualToString:tagAttributeValue]) {
                    return [element copy];
                }
            }
        }
    }
    return nil;
}

+ (NSArray *)getAllNodeFromXmlFile:(GDataXMLDocument *)doc tagName:(NSString *)tagName {
    if (doc == nil) { return nil; }
    
    NSString *xPath = [[NSString alloc] initWithFormat:@"//%@",tagName];
    NSArray *elements = [doc nodesForXPath:xPath error:nil];
    
    NSMutableArray *characterArray = [[NSMutableArray alloc] init];
    
    for (GDataXMLElement *element in elements) {
        [characterArray addObject:element];
    }
    
    return characterArray;
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
            //            NSLog(@"targetFile:%@",fileName);
            [targetFileNameArray addObject:path];
        }
    }
    
    return targetFileNameArray;
}

+(void)updateCharacterElements {
    [self sharedFileManager].characterElements = nil;
    [self sharedFileManager].characterElements = [FileManager getAllNodeFromXmlFile:[FileManager loadGDataXMLDocumentFromFileName:@"SelectedCharacters.xml"] tagName:@"character"];
}

+(void)loadAnimation {
    [self sharedFileManager].animationDictionary = [NSMutableDictionary dictionary];
    NSArray *allAnimations = [FileManager getAllFilePathsInDirectory:@"Animation" fileType:@"plist"];
    
    for (NSString *path in allAnimations) {
        NSArray *fileArray = [path componentsSeparatedByString:@"/"];
        NSString *fileName = [fileArray lastObject];
        
        NSDictionary *clip = [AKHelpers animationClipFromPlist:path];
        [[self sharedFileManager].animationDictionary setValue:clip forKey:fileName];
    }
}

+(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName {
    // ex: animationName = Animation_Swordsman_walking_Down.plist
    
    if (![self sharedFileManager].animationDictionary) {
        [self loadAnimation];
    }
    
    return [[self sharedFileManager].animationDictionary objectForKey:animationName];
}

+ (GDataXMLDocument *)getCharacterBasicData {
    return [self sharedFileManager].characterDataFile;
}

+ (void)saveCharacterArray:(NSArray *)characterArray {
    GDataXMLElement * partyElement = [GDataXMLNode elementWithName:@"party"];
    int i=0;
    for (Character *character in characterArray) {
        GDataXMLElement * characterElement =
        [GDataXMLNode elementWithName:@"character"];
        NSString *count = [NSString stringWithFormat:@"%03d",i];
        [characterElement addAttribute:[GDataXMLNode elementWithName:@"ol" stringValue:count]];
        
        [characterElement addAttribute:[GDataXMLNode elementWithName:@"id" stringValue:character.characterId]];
        NSString *levelString = [NSString stringWithFormat:@"%d",character.level];
        [characterElement addAttribute:[GDataXMLNode elementWithName:@"level" stringValue:levelString]];
        [partyElement addChild:characterElement];
        i=i+1;
    }
    GDataXMLDocument *document = [[GDataXMLDocument alloc]
                                  initWithRootElement:partyElement];
    NSData *xmlData = document.XMLData;
    
    NSString *filePath = [self dataFilePath:@"SelectedCharacters.xml" forSave:TRUE];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
    
    [self updateCharacterElements];
}

+ (NSArray *)getChararcterArray {
    
    NSMutableArray *tempCharacterArray = [NSMutableArray array];
    for (GDataXMLElement *element in [self sharedFileManager].characterElements) {
        Character *character = [[Character alloc] initWithXMLElement:element];
        [tempCharacterArray addObject:character];
    }
    
    return tempCharacterArray;
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

+(BattleSetObject *)loadBattleInfo:(NSString *)name {
    //TODO: load battle info from battle.file ?
    // ex: BattleData.xml
    GDataXMLDocument *battleInfoDoc = [self loadGDataXMLDocumentFromFileName:@"BattleData.xml"];
    GDataXMLElement *characterElement = [FileManager getNodeFromXmlFile:battleInfoDoc tagName:@"battle" tagAttributeName:@"name" tagAttributeValue:name];
    
    NSString *mapName;
    NSString *backgroundMusicName;
    
    //get tag's attributes
    for (GDataXMLNode *attribute in characterElement.attributes) {
        if ([attribute.name isEqualToString:@"map"]) {
            mapName = attribute.stringValue;
        } else if([attribute.name isEqualToString:@"bgm"]) {
            backgroundMusicName = attribute.stringValue;
        }
    }
    
    NSMutableArray *enemyArray = [NSMutableArray array];
    NSMutableArray *enemyBosses = [NSMutableArray array];
    Character *enemyCastle;
    
    for (GDataXMLElement *element in characterElement.children) {
        if ([element.name isEqualToString:@"enemies"]) {
            for (GDataXMLElement *enemy in element.children) {
                Character *character = [[Character alloc] initWithXMLElement:enemy];
                [enemyArray addObject:character];
            }
        }
        if ([element.name isEqualToString:@"bosses"]) {
            for (GDataXMLElement *boss in element.children) {
                Character *character = [[Character alloc] initWithXMLElement:boss];
                [enemyBosses addObject:character];
            }
        }
        if ([element.name isEqualToString:@"enemyCastle"]) {
            for (GDataXMLElement *castle in element.children) {
                enemyCastle = [[Character alloc] initWithXMLElement:castle];
                break;
            }
        }
    }
    
    BattleSetObject *battleData = [[BattleSetObject alloc] initWithBattleName:name];
    
    
    battleData.playerCharacterArray = [self getChararcterArray];
    battleData.battleEnemyArray = enemyArray;
    battleData.enemyBossArray = enemyBosses;
    battleData.enemyCastle = enemyCastle;
    
    //FIXME: load castle from file
    GDataXMLDocument *castleElement = [FileManager loadGDataXMLDocumentFromFileName:@"AllCharacter.xml"];
    Character *playerCastle = [[Character alloc] initWithXMLElement:[FileManager getNodeFromXmlFile:castleElement tagName:@"character" tagAttributeName:@"castle" tagAttributeValue:@"001"]];
    NSLog(@"castle :: %@", playerCastle.name);
    NSLog(@"enemyCastle :: %@", enemyCastle.name);
    battleData.playerCastle = playerCastle;
    
    return battleData;
}

-(void)playBackgroundMusic:(NSString *)name {
    
    NSArray *music = [FileManager getAllFilePathsInDirectory:@"BackgroundMusic_caf" withPrefix:name fileType:@"caf"];
    
    NSString *fileName = [music lastObject];
    
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:fileName];
}


@end
