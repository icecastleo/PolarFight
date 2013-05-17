//
//  UserDataObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import "UserDataObject.h"
#import "CharacterInitData.h"
#import "Character.h"
#import "Property.h"
#import "Achievement.h"
#import "PlistDictionaryInitialing.h"

#define kMoneyTrickValue 1000

#define kMoney @"money"
#define kCastle @"castle"
#define kHero @"hero"
#define kCharacters @"characters"
#define kItemArray @"items"
#define kSoundsEffectVolume @"soundsEffectVolume"
#define kBackgroundMucsicVolume @"backgroundMusicVolume"
#define kSoundsEffectSwitch @"soundsEffectSwitch"
#define kBackgroundMucsicSwitch @"backgroundMusicSwitch"
#define kAchievements @"achievements"
#define kProperties @"properties"

@interface UserDataObject() {
    NSNumber *moneyNumber;
}
@property NSArray *playerHeroArray;
@property NSArray *playerCastleArray;
@property NSArray *items;

@end

@implementation UserDataObject

@dynamic money;

-(id)initWithPlistPath:(NSString *)path {
    if (self = [super init]) {
        NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        moneyNumber = [plist objectForKey:kMoney];
        _soundsEffectVolume = [[plist objectForKey:kSoundsEffectVolume] floatValue];
        _backgroundMusicVolume = [[plist objectForKey:kBackgroundMucsicVolume] floatValue];
        _soundsEffectSwitch = [[plist objectForKey:kSoundsEffectSwitch] boolValue];
        _backgroundMusicSwitch = [[plist objectForKey:kBackgroundMucsicSwitch] boolValue];
        
        //all character array keep CharacterDataObject.
        _characterInitDatas = [self convertArray:[plist objectForKey:kCharacters] className:[CharacterInitData class]];
//        _playerHeroArray = [self convertArray:[plist objectForKey:kHero] className:[CharacterInitData class]];
//        _playerCastleArray = [self convertArray:[plist objectForKey:kCastle] className:[CharacterInitData class]];
        _achievements = [self convertArray:[plist objectForKey:kAchievements] className:[Achievement class]];
        _properties = [self convertArray:[plist objectForKey:kProperties] className:[Property class]];
        
        //FIXME: [CharacterDataObject class] change to item class?
        _items = [self convertArray:[plist objectForKey:kItemArray] className:[CharacterInitData class]];
    }
    return self;
}

-(void)setMoney:(int)money {
    moneyNumber = [NSNumber numberWithInt:money + kMoneyTrickValue];
    
    NSNotification *notification = [NSNotification notificationWithName:@"MoneyChangedNotify" object:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

-(int)money {
    return [moneyNumber intValue] - kMoneyTrickValue;
}

-(NSArray *)convertArray:(NSArray *)array className:(Class)className {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        Class<PlistDictionaryInitialing> __autoreleasing class = [[className alloc] initWithDictionary:dic];
        [tempArray addObject:class];
    }
    return tempArray;
}

//-(Character *)getPlayerHero {
//    CharacterInitData *data = [self.playerHeroArray lastObject];
//    Character *hero = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
//    return hero;
//}
//-(Character *)getPlayerCastle {
//    CharacterInitData *data = [self.playerCastleArray lastObject];
//    Character *castle = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
//    return castle;
//}
//
//-(NSArray *)getPlayerCharacterArray {
//    
//    NSMutableArray *characterArray = [NSMutableArray array];
//    
//    for (CharacterInitData *data in self.playerCharacterArray) {
//        Character *character = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
//        [characterArray addObject:character];
//    }
//    
//    return characterArray;
//}
//
//-(void)updatePlayerCharacter:(Character *)character inArray:(NSArray *)array {
//    for (CharacterInitData *data in array) {
//        if ([data.cid isEqualToString:character.characterId]) {
//            data.level = [NSString stringWithFormat:@"%d",character.level];
//            return;
//        }
//    }
//}
//
//-(void)updatePlayerCharacter:(Character *)character {
//    [self updatePlayerCharacter:character inArray:self.playerCharacterArray];
//    [self updatePlayerCharacter:character inArray:self.playerHeroArray];
//    [self updatePlayerCharacter:character inArray:self.playerCastleArray];
//}

#pragma mark NSCoding    
    
-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _characterInitDatas = [decoder decodeObjectForKey:kCharacters];
//        _playerHeroArray = [decoder decodeObjectForKey:kHero];
//        _playerCastleArray = [decoder decodeObjectForKey:kCastle];
        moneyNumber = [decoder decodeObjectForKey:kMoney];
        _items = [decoder decodeObjectForKey:kItemArray];
        _soundsEffectVolume = [decoder decodeFloatForKey:kSoundsEffectVolume];
        _backgroundMusicVolume = [decoder decodeFloatForKey:kBackgroundMucsicVolume];
        _soundsEffectSwitch = [decoder decodeBoolForKey:kSoundsEffectSwitch];
        _backgroundMusicSwitch = [decoder decodeBoolForKey:kBackgroundMucsicSwitch];
        _achievements = [decoder decodeObjectForKey:kAchievements];
        _properties = [decoder decodeObjectForKey:kProperties];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_characterInitDatas forKey:kCharacters];
//    [encoder encodeObject:_playerHeroArray forKey:kHero];
//    [encoder encodeObject:_playerCastleArray forKey:kCastle];
    [encoder encodeObject:moneyNumber forKey:kMoney];
    [encoder encodeObject:_items forKey:kItemArray];
    [encoder encodeFloat:_soundsEffectVolume forKey:kSoundsEffectVolume];
    [encoder encodeFloat:_backgroundMusicVolume forKey:kBackgroundMucsicVolume];
    [encoder encodeBool:_soundsEffectSwitch forKey:kSoundsEffectSwitch];
    [encoder encodeBool:_backgroundMusicSwitch forKey:kBackgroundMucsicSwitch];
    [encoder encodeObject:_achievements forKey:kAchievements];
    [encoder encodeObject:_properties forKey:kProperties];
}

@end
