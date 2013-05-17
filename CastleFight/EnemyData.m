//
//  CharacterData.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/14.
//
//

#import "EnemyData.h"
#import "FileManager.h"

@implementation EnemyData

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _cid = [dic objectForKey:@"id"];
        _level = [[dic objectForKey:@"level"] intValue];
        _targetRatio = [[dic objectForKey:@"targetRatio"] intValue];
        
        NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithCid:_cid];
        _cost = [[characterData objectForKey:@"cost"] intValue];
    }
    return self;
}

@end
