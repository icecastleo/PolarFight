//
//  OrbSkillData.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/3.
//
//

#import "OrbSkillData.h"
#import "FileManager.h"
#import "AchievementManager.h"

#define kOrbSkillMaxLevel @"maxLevel"

@implementation OrbSkillData

@dynamic level;

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super initWithDictionary:dic]) {
        _maxLevel = [[dic objectForKey:kOrbSkillMaxLevel] intValue];
    }
    return self;
}

-(int)level {
    return [[FileManager sharedFileManager].achievementManager getValueFromProperty:[self.name stringByAppendingString:@"_level"]];
}


#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [super encodeWithCoder:encoder];
    [encoder encodeObject:[NSNumber numberWithInt:_maxLevel] forKey:kOrbSkillMaxLevel];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        _maxLevel = [[decoder decodeObjectForKey:kOrbSkillMaxLevel] intValue];
    }
    return self;
}

@end
