//
//  UserDataObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import "UserDataObject.h"
#import "CharacterData.h"
#import "Character.h"

@implementation UserDataObject

-(id)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

-(NSArray *)getCharacterArrayFromArray:(NSArray *)array {
    NSMutableArray *tempCharacterArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        CharacterData *characterData = [[CharacterData alloc] initWithDictionary:dic];
        [tempCharacterArray addObject:characterData];
    }
    return tempCharacterArray;
}

-(id)initWithPlistPath:(NSString *)path {
    if (self = [super init]) {
        NSMutableDictionary *tempPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        _money = [tempPlist objectForKey:@"money"];
        _playerCharacterArray = [self getCharacterArrayFromArray:[tempPlist objectForKey:@"characters"]];
        _playerHeroArray = [self getCharacterArrayFromArray:[tempPlist objectForKey:@"heroes"]];
        _playerCastleArray = [self getCharacterArrayFromArray:[tempPlist objectForKey:@"castle"]];
        _items = [self getCharacterArrayFromArray:[tempPlist objectForKey:@"items"]];
    
    }
    return self;
}

-(Character *)getPlayerHero {
    CharacterData *data = [self.playerHeroArray lastObject];
    Character *hero = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
    return hero;
}
-(Character *)getPlayerCastle {
    
    CharacterData *data = [self.playerCastleArray lastObject];
    Character *castle = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
    return castle;
}

-(NSArray *)getPlayerCharacterArray {
    
    NSMutableArray *characterArray = [NSMutableArray array];
    
    for (CharacterData *data in self.playerCharacterArray) {
        Character *character = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
        [characterArray addObject:character];
    }
    
    return characterArray;
}

#pragma mark NSCoding

#define kMoneyKey       @"Money"
#define kCastleKey      @"Castle"
#define kHeroKey      @"Hero"
#define kCharacterArrayKey      @"CharacterArray"
#define kItemArrayKey      @"ItemArray"

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_playerCharacterArray forKey:kCharacterArrayKey];
    [encoder encodeObject:_playerHeroArray forKey:kHeroKey];
    [encoder encodeObject:_playerCastleArray forKey:kCastleKey];
    [encoder encodeObject:_money forKey:kMoneyKey];
    [encoder encodeObject:_items forKey:kItemArrayKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSArray *characterArray = [decoder decodeObjectForKey:kCharacterArrayKey];
    NSArray *hero = [decoder decodeObjectForKey:kHeroKey];
    NSArray *castle = [decoder decodeObjectForKey:kCastleKey];
    NSString *money = [decoder decodeObjectForKey:kMoneyKey];
    NSArray *items = [decoder decodeObjectForKey:kItemArrayKey];
    
    if (self = [super init]) {
        _playerCharacterArray = characterArray;
        _playerHeroArray = hero;
        _playerCastleArray = castle;
        _money = money;
        _items = items;
    }
    
    return self;
}

@end
