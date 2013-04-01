//
//  Achievement.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//

#import "Achievement.h"

#define kNameKey       @"name"
#define kPropertyNamesKey      @"propertyNames"
#define kUnLockedKey       @"unLocked"

@implementation Achievement

-(id)initWithAchievementName:(NSString *)name theRelatedPropertyNames:(NSArray *)propertyNames {
    if (self = [super init]) {
        _name = name;
        _propertyNames = propertyNames;
        _unLocked = NO;
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _name = [dic objectForKey:@"name"];
        _propertyNames = [dic objectForKey:@"propertyNames"];
        _unLocked = [[dic objectForKey:@"unLocked"] boolValue];
    }
    return self;
}

-(NSString *)description {
    NSString *status = self.unLocked ? @"unlocked" : @"locked";
    NSString *description = [NSString stringWithFormat:@"[Achievement: %@ status:%@]",self.name, status];
    return description;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:kNameKey];
    [encoder encodeObject:_propertyNames forKey:kPropertyNamesKey];
    [encoder encodeBool:_unLocked forKey:kUnLockedKey];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _name = [decoder decodeObjectForKey:kNameKey];
        _propertyNames = [decoder decodeObjectForKey:kPropertyNamesKey];
        _unLocked = [decoder decodeBoolForKey:kUnLockedKey];
    }
    return self;
}

@end
