//
//  CharacterData.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/20.
//
//

#import "CharacterInitData.h"

#define kId     @"id"
#define kLevel  @"level"

@implementation CharacterInitData

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _cid = [dic objectForKey:kId];
        _level = [[dic objectForKey:kLevel] intValue];
    }
    return self;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_cid forKey:kId];
    [encoder encodeObject:[NSNumber numberWithInt:_level] forKey:kLevel];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _cid = [decoder decodeObjectForKey:kId];
        _level = [[decoder decodeObjectForKey:kLevel] intValue];
    }
    
    return self;
}
@end
