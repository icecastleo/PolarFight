//
//  CharacterData.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import "CharacterDataObject.h"

#define kIdKey       @"Id"
#define kLevelKey      @"Level"

@implementation CharacterDataObject

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _characterId = [dic objectForKey:@"id"];
        _level = [dic objectForKey:@"level"];
    }
    return self;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_characterId forKey:kIdKey];
    [encoder encodeObject:_level forKey:kLevelKey];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _characterId = [decoder decodeObjectForKey:kIdKey];
        _level = [decoder decodeObjectForKey:kLevelKey];
    }
    
    return self;
}
@end
