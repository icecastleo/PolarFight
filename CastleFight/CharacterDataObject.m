//
//  CharacterData.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import "CharacterDataObject.h"

#define kId       @"id"
#define kLevel      @"level"

@implementation CharacterDataObject

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _characterId = [dic objectForKey:kId];
        _level = [dic objectForKey:kLevel];
    }
    return self;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_characterId forKey:kId];
    [encoder encodeObject:_level forKey:kLevel];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _characterId = [decoder decodeObjectForKey:kId];
        _level = [decoder decodeObjectForKey:kLevel];
    }
    
    return self;
}
@end
