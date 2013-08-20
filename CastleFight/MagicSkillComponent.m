//
//  MagicSkillComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/7/5.
//
//

#import "MagicSkillComponent.h"

@implementation MagicSkillComponent

+(NSString *)name {
    static NSString *name = @"MagicSkillComponent";
    return name;
}

-(id)init {
    if (self = [super init]) {
        _magicTeam = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
