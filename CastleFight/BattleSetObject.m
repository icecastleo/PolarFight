//
//  BattleSetObject.m
//  CastleFight
//
//  Created by  DAN on 13/3/5.
//
//

#import "BattleSetObject.h"
#import "PartyParser.h"
#import "SimpleAudioEngine.h"
#import "GDataXMLNode.h"
#import "XmlParser.h"
#import "AKHelpers.h"

@interface BattleSetObject ()

@property (nonatomic) NSArray *sounds;

@end

@implementation BattleSetObject

-(id)initWithBattleName:(NSString *)name {
    
    if (self = [super init]) {
        _sceneName = name;
        
        [self playBackgroundMusic:name];
        [self preloadSoundEffect:name];
        
        if ([name hasPrefix:@"battle"]) {
            [self loadCharacterFile:name];
            
        }
    }
    return self;
}

-(void)playBackgroundMusic:(NSString *)name {
    // ex: bgm_sceneName.mp3 (backgroundMusic)
    if ([name hasPrefix:@"battle"]) {
        // TODO: some batlle have different bgm.
        name = @"battle";
    }
    NSString *prefix = [NSString stringWithFormat:@"bgm_%@",name];
    NSArray *music = [PartyParser getAllFilePathsInDirectory:@"Sound_caf" withPrefix:prefix fileType:@"caf"];
    
    NSString *fileName = [music lastObject];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:fileName];
}

-(void)preloadSoundEffect:(NSString *)name {
    // ex: Effect_sceneName_xxx.caf
    if ([name hasPrefix:@"battle"]) {
        // All battle scene has the same sound effect？
        name = @"battle";
    }
    NSString *prefix = [NSString stringWithFormat:@"bgm_%@",name];
    _sounds = [PartyParser getAllFilePathsInDirectory:@"Sound_caf" withPrefix:prefix fileType:@"caf"];
    
    for (NSString *fileName in self.sounds) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:fileName];
    }
}

-(void)loadCharacterFile:(NSString *)name {
    //TODO: load battle info from battle.file ?
    
    // 1.CharacterData.xml (All character)
    _characterDataFile = [self loadFile:@"CharacterData.xml"];
    
    _allCharacterFile = [self loadFile:@"AllCharacter.xml"];
    
    // 2.player1 Character file (saveFile)
    _playerCharacterFile = [self loadFile:@"SelectedCharacters.xml"];
    
    //TODO: select emeny file by Name
    // 3.player2 character file (enemy of the battle)
    _battleEnemyFile = [self loadFile:@"TestPlayer2.xml"];
    // ex: Enemy_battleName.xml
    
}

-(GDataXMLDocument *)loadFile:(NSString *)fileName {
    NSString *filePath = [PartyParser dataFilePath:fileName];
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    NSError *error;
    
    return [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
}

-(void)dealloc {
    //TODO: unload soundeffect
    for (NSString *fileName in self.sounds) {
        [[SimpleAudioEngine sharedEngine] unloadEffect:fileName];
    }
    
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
}

@end
