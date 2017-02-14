//
//  UserDataObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import "UserDataObject.h"
#import "CharacterInitData.h"
#import "Property.h"
#import "Achievement.h"
#import "PlistDictionaryInitialing.h"
#import "OrbSkillData.h"
#import "ItemData.h"

#define kMoneyTrickValue 1000

#define kMoney @"money"
#define kCastle @"castle"
#define kHero @"heros"
#define kCharacters @"characters"
#define kItems @"items"
#define kItemsInBattle @"itemsInBattle"
#define kSoundsEffectVolume @"soundsEffectVolume"
#define kBackgroundMucsicVolume @"backgroundMusicVolume"
#define kSoundsEffectEnable @"soundsEffectEnable"
#define kBackgroundMucsicEnable @"backgroundMusicEnable"
#define kAchievements @"achievements"
#define kProperties @"properties"
#define kBattleTeam @"battleTeam"
#define kMagicTeam @"magicTeam"
#define kMagicInBattle @"magicInBattle"
#define kOrbSkills @"orbSkills"
#define kOrbSkillProperties @"orbSkillProperties"
#define kMagicProperties @"magicProperties"

@interface UserDataObject() {
    NSNumber *moneyNumber;
}
//@property NSArray *playerHeroArray;
@property NSArray *playerCastleArray;

@end

@implementation UserDataObject

@dynamic money;

-(id)initWithPlistPath:(NSString *)path {
    if (self = [super init]) {
        NSMutableDictionary *plist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        moneyNumber = [plist objectForKey:kMoney];
        _soundsEffectVolume = [[plist objectForKey:kSoundsEffectVolume] floatValue];
        _backgroundMusicVolume = [[plist objectForKey:kBackgroundMucsicVolume] floatValue];
        _soundsEffectSwitch = [[plist objectForKey:kSoundsEffectEnable] boolValue];
        _backgroundMusicSwitch = [[plist objectForKey:kBackgroundMucsicEnable] boolValue];
        
        //all character array keep CharacterDataObject.
        _characterInitDatas = [self convertArray:[plist objectForKey:kCharacters] className:[CharacterInitData class]];
        _playerHeroArray = [self convertArray:[plist objectForKey:kHero] className:[CharacterInitData class]];
//        _playerCastleArray = [self convertArray:[plist objectForKey:kCastle] className:[CharacterInitData class]];
        _battleTeam = [self convertArray:[plist objectForKey:kBattleTeam] className:[CharacterInitData class]];
        _magicTeam = [self convertArray:[plist objectForKey:kMagicTeam] className:[OrbSkillData class]];
        _magicInBattle = [plist objectForKey:kMagicInBattle];
        
        _achievements = [self convertArray:[plist objectForKey:kAchievements] className:[Achievement class]];
        _properties = [self convertArray:[plist objectForKey:kProperties] className:[Property class]];
        
        _orbSkills = [self convertArray:[plist objectForKey:kOrbSkills] className:[OrbSkillData class]];
        _orbSkillProperties = [self convertArray:[plist objectForKey:kOrbSkillProperties] className:[Property class]];
        _magicProperties = [self convertArray:[plist objectForKey:kMagicProperties] className:[Property class]];
        
        //FIXME: [CharacterDataObject class] change to item class?
        _items = [self convertArray:[plist objectForKey:kItems] className:[ItemData class]];
        _itemsInBattle = [plist objectForKey:kItemsInBattle];
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
 
#pragma mark NSCoding    
    
-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _characterInitDatas = [decoder decodeObjectForKey:kCharacters];
        _playerHeroArray = [decoder decodeObjectForKey:kHero];
//        _playerCastleArray = [decoder decodeObjectForKey:kCastle];
        _battleTeam = [decoder decodeObjectForKey:kBattleTeam];
        _magicTeam = [decoder decodeObjectForKey:kMagicTeam];
        _magicInBattle = [decoder decodeObjectForKey:kMagicInBattle];
        
        moneyNumber = [decoder decodeObjectForKey:kMoney];
        _items = [decoder decodeObjectForKey:kItems];
        _itemsInBattle = [decoder decodeObjectForKey:kItemsInBattle];
        _soundsEffectVolume = [decoder decodeFloatForKey:kSoundsEffectVolume];
        _backgroundMusicVolume = [decoder decodeFloatForKey:kBackgroundMucsicVolume];
        _soundsEffectSwitch = [decoder decodeBoolForKey:kSoundsEffectEnable];
        _backgroundMusicSwitch = [decoder decodeBoolForKey:kBackgroundMucsicEnable];
        _achievements = [decoder decodeObjectForKey:kAchievements];
        _properties = [decoder decodeObjectForKey:kProperties];
        
        _orbSkills = [decoder decodeObjectForKey:kOrbSkills];
        _orbSkillProperties = [decoder decodeObjectForKey:kOrbSkillProperties];
        _magicProperties = [decoder decodeObjectForKey:kMagicProperties];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_characterInitDatas forKey:kCharacters];
    [encoder encodeObject:_playerHeroArray forKey:kHero];
//    [encoder encodeObject:_playerCastleArray forKey:kCastle];
    [encoder encodeObject:_battleTeam forKey:kBattleTeam];
    [encoder encodeObject:_magicTeam forKey:kMagicTeam];
    [encoder encodeObject:_magicInBattle forKey:kMagicInBattle];
    
    [encoder encodeObject:moneyNumber forKey:kMoney];
    [encoder encodeObject:_items forKey:kItems];
    [encoder encodeObject:_itemsInBattle forKey:kItemsInBattle];
    [encoder encodeFloat:_soundsEffectVolume forKey:kSoundsEffectVolume];
    [encoder encodeFloat:_backgroundMusicVolume forKey:kBackgroundMucsicVolume];
    [encoder encodeBool:_soundsEffectSwitch forKey:kSoundsEffectEnable];
    [encoder encodeBool:_backgroundMusicSwitch forKey:kBackgroundMucsicEnable];
    [encoder encodeObject:_achievements forKey:kAchievements];
    [encoder encodeObject:_properties forKey:kProperties];
    
    [encoder encodeObject:_orbSkills forKey:kOrbSkills];
    [encoder encodeObject:_orbSkillProperties forKey:kOrbSkillProperties];
    [encoder encodeObject:_magicProperties forKey:kMagicProperties];
}

@end
