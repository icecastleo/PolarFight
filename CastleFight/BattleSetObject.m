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
#import "CCSpriteBatchNode.h"
#import "CCSpriteFrameCache.h"
#import "AKHelpers.h"

@implementation BattleSetObject

-(id)initWithBattleName:(NSString *)name {
    
    if (self = [super init]) {
        _battleName = name;
        
        [self playBackgroundMusic:name];
        [self preloadSoundEffect:name];
        [self loadCharacterFile:name];
        [self loadAnimation:name];

        _battleAnimations = [self getAnimationDictionaryByName:name];
    }
    return self;
}

-(void)playBackgroundMusic:(NSString *)name {
    // ex: bgm_battleName.mp3 (backgroundMusic)
    NSString *prefix = [NSString stringWithFormat:@"bgm_%@",name];
    NSArray *music = [PartyParser getAllFilePathsInDirectory:@"Sound_caf" withPrefix:prefix fileType:@"caf"];
    
    NSString *fileName = [music lastObject];
    [[SimpleAudioEngine sharedEngine] playBackgroundMusic:fileName];
}

-(void)preloadSoundEffect:(NSString *)name {
    // ex: Effect_xxx.caf
    NSString *prefix = @"Effect_";
    NSArray *sounds = [PartyParser getAllFilePathsInDirectory:@"Sound_caf" withPrefix:prefix fileType:@"caf"];
    
    for (NSString *fileName in sounds) {
        [[SimpleAudioEngine sharedEngine] preloadEffect:fileName];
    }
}

-(void)loadCharacterFile:(NSString *)name {
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

-(void)loadAnimation:(NSString *)name {
    // Animation_Swordsman_walking_Down.plist
    // ex: Animation_xxx.plist
    
    _animationDictionary = [NSMutableDictionary dictionary];
    NSArray *allAnimations = [PartyParser getAllFilePathsInDirectory:@"Animation" fileType:@"plist"];
    
    for (NSString *path in allAnimations) {
        NSArray *fileArray = [path componentsSeparatedByString:@"/"];
        NSString *fileName = [fileArray lastObject];
        
        NSDictionary *clip = [AKHelpers animationClipFromPlist:path];
        [_animationDictionary setValue:clip forKey:fileName];
    }
}

-(NSDictionary *)getAnimationDictionaryByName:(NSString *)animationName {

    NSString *prefix = [NSString stringWithFormat:@"Animation_%@",animationName];

    NSMutableDictionary *animationDic = [NSMutableDictionary dictionary];
    
    for (NSString *key in self.animationDictionary) {
        if ([key hasPrefix:prefix]) {
            [animationDic setObject:[self.animationDictionary objectForKey:key] forKey:key];
        }
    }
    
    return animationDic;
}

@end
