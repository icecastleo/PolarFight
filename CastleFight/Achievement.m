//
//  Achievement.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//

#import "Achievement.h"

#define kName       @"name"
#define kPropertyNames      @"propertyNames"
#define kUnLocked      @"unLocked"
#define kMessage       @"message"
#define kContent       @"content"
#define kPercentage    @"percentage"

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
        _name = [dic objectForKey:kName];
        _propertyNames = [dic objectForKey:kPropertyNames];
        _unLocked = [[dic objectForKey:kUnLocked] boolValue];
        _message = [dic objectForKey:kMessage];
        _content = [dic objectForKey:kContent];
        _percentage = [[dic objectForKey:kPercentage] doubleValue];
        if (self.unLocked) {
            _percentage = 1.0;
        }
    }
    return self;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:kName];
    [encoder encodeObject:_propertyNames forKey:kPropertyNames];
    [encoder encodeBool:_unLocked forKey:kUnLocked];
    [encoder encodeObject:_message forKey:kMessage];
    [encoder encodeObject:_content forKey:kContent];
    [encoder encodeDouble:_percentage forKey:kPercentage];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _name = [decoder decodeObjectForKey:kName];
        _propertyNames = [decoder decodeObjectForKey:kPropertyNames];
        _unLocked = [decoder decodeBoolForKey:kUnLocked];
        _message = [decoder decodeObjectForKey:kMessage];
        _content = [decoder decodeObjectForKey:kContent];
        _percentage = [decoder decodeDoubleForKey:kPercentage];
    }
    return self;
}

@end
