//
//  CharacterData.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import "CharacterData.h"

@implementation CharacterData

-(id)init {
    
    if (self = [super init]) {
        
    }
    return self;
}


-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _characterId = [dic objectForKey:@"id"];
        _level = [dic objectForKey:@"level"];
    }
    return self;
}

#pragma mark NSCoding

#define kIdKey       @"Id"
#define kLevelKey      @"Level"

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:_characterId forKey:kIdKey];
    [encoder encodeObject:_level forKey:kLevelKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    NSString *tempId = [decoder decodeObjectForKey:kIdKey];
    NSString *tempLevel = [decoder decodeObjectForKey:kLevelKey];
    
    if (self = [super init]) {
        _characterId = tempId;
        _level = tempLevel;
    }
    
    return self;
}
@end
