//
//  BattleSetObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/5.
//
//

#import "BattleSetObject.h"
#import "PartyParser.h"
#import "SimpleAudioEngine.h"
#import "GDataXMLNode.h"
#import "AKHelpers.h"

@interface BattleSetObject (){
    NSString *backgroundMusicName;
}

@property (nonatomic) NSArray *sceneSounds;
@property (nonatomic) NSArray *characterSounds;

@end

@implementation BattleSetObject

-(id)initWithBattleName:(NSString *)name {
    
    if (self = [super init]) {
        _sceneName = name;
        
        if ([name hasPrefix:@"battle"]) {
            [self loadBattleInfo:name];
            [self preloadCharacterSoundEffect];
        }else {
            [self loadSceneInfo:name];
        }
        
        [self playBackgroundMusic:backgroundMusicName];
        [self preloadSoundEffect:name];
    }
    return self;
}

-(void)playBackgroundMusic:(NSString *)name {
    
    NSArray *music = [PartyParser getAllFilePathsInDirectory:@"BackgroundMusic_caf" withPrefix:name fileType:@"caf"];
    
    NSString *fileName = [music lastObject];
    
    // If you have All Exceptions BreakPoint, you can not play the background music.
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:fileName];
    
}

-(void)preloadSoundEffect:(NSString *)name {
    // ex: Effect_sceneName_xxx.caf
    if ([name hasPrefix:@"battle"]) {
        name = @"battle";
    }
    NSString *prefix = [NSString stringWithFormat:@"Effect_%@",name];
    _sceneSounds = [PartyParser getAllFilePathsInDirectory:@"Sound_scene_caf" withPrefix:prefix fileType:@"caf"];
    
    for (NSString *fileName in self.sceneSounds) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:fileName];
    }
}

-(void)preloadCharacterSoundEffect {
    _characterSounds = [PartyParser getAllFilePathsInDirectory:@"Sound_character_caf" fileType:@"caf"];
    for (NSString *fileName in self.characterSounds) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:fileName];
    }
}

-(void)loadSceneInfo:(NSString *)name {
    GDataXMLDocument *battleInfoDoc = [self loadFile:@"BattleData.xml"];
    GDataXMLElement *characterElement = [PartyParser getNodeFromXmlFile:battleInfoDoc tagName:@"menu" tagAttributeName:@"name" tagAttributeValue:name];
    
    //get tag's attributes
    for (GDataXMLNode *attribute in characterElement.attributes) {
        if([attribute.name isEqualToString:@"bgm"]) {
            backgroundMusicName = attribute.stringValue;
        }
    }
}

-(void)loadBattleInfo:(NSString *)name {
    //TODO: load battle info from battle.file ?
    // ex: BattleData.xml
    GDataXMLDocument *battleInfoDoc = [self loadFile:@"BattleData.xml"];
    GDataXMLElement *characterElement = [PartyParser getNodeFromXmlFile:battleInfoDoc tagName:@"battle" tagAttributeName:@"name" tagAttributeValue:name];
    
    //get tag's attributes
    for (GDataXMLNode *attribute in characterElement.attributes) {
        if ([attribute.name isEqualToString:@"map"]) {
            _mapName = attribute.stringValue;
        } else if([attribute.name isEqualToString:@"bgm"]) {
            backgroundMusicName = attribute.stringValue;
        }
    }
    
    NSMutableArray *enemyArray = [NSMutableArray array];
    NSMutableArray *enemyBosses = [NSMutableArray array];
    
    for (GDataXMLElement *element in characterElement.children) {
        if ([element.name isEqualToString:@"enemies"]) {
            for (GDataXMLElement *enemy in element.children) {
                [enemyArray addObject:enemy];
            }
        }
        if ([element.name isEqualToString:@"bosses"]) {
            for (GDataXMLElement *boss in element.children) {
                [enemyBosses addObject:boss];
            }
        }
        if ([element.name isEqualToString:@"enemyCastle"]) {
            for (GDataXMLElement *castle in element.children) {
                _enemyCastle = castle;
                break;
            }
        }
    }
    
    // 1.CharacterData.xml (All character)
    _characterDataFile = [self loadFile:@"CharacterData.xml"];
    
    //TODO: select emeny file by Name
    // 3.player2 character file (enemy of the battle)
    _enemyBossArray = enemyBosses;
    _battleEnemyArray = enemyArray;
    
}

-(GDataXMLDocument *)loadFile:(NSString *)fileName {
    NSString *filePath = [PartyParser dataFilePath:fileName];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    
    return [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
}

-(void)dealloc {
    // unload soundeffect
    for (NSString *fileName in self.sceneSounds) {
        [[SimpleAudioEngine sharedEngine] unloadEffect:fileName];
    }
    for (NSString *fileName in self.characterSounds) {
        [[SimpleAudioEngine sharedEngine] unloadEffect:fileName];
    }
}

@end
