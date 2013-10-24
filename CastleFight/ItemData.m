//
//  ItemData.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/24.
//
//

#import "ItemData.h"

#define kId     @"itemId"
#define kCount  @"count"

@implementation ItemData

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _itemId = [dic objectForKey:kId];
        _count = [[dic objectForKey:kCount] intValue];
    }
    return self;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_itemId forKey:kId];
    [encoder encodeObject:[NSNumber numberWithInt:_count] forKey:kCount];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _itemId = [decoder decodeObjectForKey:kId];
        _count = [[decoder decodeObjectForKey:kCount] intValue];
    }
    
    return self;
}

@end
