//
//  CharacterData.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import "CharacterDataObject.h"

@implementation CharacterDataObject

-(id)init {
    
    if (self = [super init]) {
        
    }
    return self;
}


-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _characterId = [dic objectForKey:@"id"];
        _level = [dic objectForKey:@"level"];
        _targetRatio = [dic objectForKey:@"targetRatio"];
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
