//
//  UserDataObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import "UserDataObject.h"
#import "CharacterDataObject.h"
#import "Character.h"

#define kMoneyTrickValue 1000

#define kMoneyKey @"money"
#define kCastleKey @"castle"
#define kHeroKey @"hero"
#define kCharacterArrayKey @"characters"
#define kItemArrayKey @"items"

@interface UserDataObject() {
    NSNumber *moneyNumber;
}
@end


@implementation UserDataObject

@dynamic money;

-(id)init {
    
    if (self = [super init]) {
        
    }
    return self;
}

-(int)money {
    return [moneyNumber intValue] - kMoneyTrickValue;
}

-(void)setMoney:(int)money {
    moneyNumber = [NSNumber numberWithInt:money + kMoneyTrickValue];
}

-(NSArray *)getCharacterArrayFromArray:(NSArray *)array {
    NSMutableArray *tempCharacterArray = [NSMutableArray array];
    
    for (NSDictionary *dic in array) {
        CharacterDataObject *characterData = [[CharacterDataObject alloc] initWithDictionary:dic];
        [tempCharacterArray addObject:characterData];
    }
    
    return tempCharacterArray;
}

-(id)initWithPlistPath:(NSString *)path {
    if (self = [super init]) {
        NSMutableDictionary *tempPlist = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
        
        moneyNumber = [tempPlist objectForKey:kMoneyKey];
        
        //all character array keep characterDataObject.
        _playerCharacterArray = [self getCharacterArrayFromArray:[tempPlist objectForKey:kCharacterArrayKey]];
        _playerHeroArray = [self getCharacterArrayFromArray:[tempPlist objectForKey:kHeroKey]];
        _playerCastleArray = [self getCharacterArrayFromArray:[tempPlist objectForKey:kCastleKey]];
        _items = [self getCharacterArrayFromArray:[tempPlist objectForKey:kItemArrayKey]];
    
    }
    return self;
}

-(Character *)getPlayerHero {
    CharacterDataObject *data = [self.playerHeroArray lastObject];
    Character *hero = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
    return hero;
}
-(Character *)getPlayerCastle {
    CharacterDataObject *data = [self.playerCastleArray lastObject];
    Character *castle = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
    return castle;
}

-(NSArray *)getPlayerCharacterArray {
    
    NSMutableArray *characterArray = [NSMutableArray array];
    
    for (CharacterDataObject *data in self.playerCharacterArray) {
        Character *character = [[Character alloc] initWithId:data.characterId andLevel:data.level.intValue];
        [characterArray addObject:character];
    }
    
    return characterArray;
}

-(void)updatePlayerCharacter:(Character *)character inArray:(NSArray *)array {
    for (CharacterDataObject *data in array) {
        if ([data.characterId isEqualToString:character.characterId]) {
            data.level = [NSString stringWithFormat:@"%d",character.level];
            return;
        }
    }
}

-(void)updatePlayerCharacter:(Character *)character {
    [self updatePlayerCharacter:character inArray:self.playerCharacterArray];
    [self updatePlayerCharacter:character inArray:self.playerHeroArray];
    [self updatePlayerCharacter:character inArray:self.playerCastleArray];
}

#pragma mark NSCoding

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _playerCharacterArray = [decoder decodeObjectForKey:kCharacterArrayKey];
        _playerHeroArray = [decoder decodeObjectForKey:kHeroKey];
        _playerCastleArray = [decoder decodeObjectForKey:kCastleKey];
        moneyNumber = [decoder decodeObjectForKey:kMoneyKey];
        _items = [decoder decodeObjectForKey:kItemArrayKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_playerCharacterArray forKey:kCharacterArrayKey];
    [encoder encodeObject:_playerHeroArray forKey:kHeroKey];
    [encoder encodeObject:_playerCastleArray forKey:kCastleKey];
    [encoder encodeObject:moneyNumber forKey:kMoneyKey];
    [encoder encodeObject:_items forKey:kItemArrayKey];
}

@end
