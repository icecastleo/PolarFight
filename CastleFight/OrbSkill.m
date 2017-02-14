//
//  OrbSkill.m
//  CastleFight
//
//  Created by  浩翔 on 13/10/1.
//
//

#import "OrbSkill.h"

@implementation OrbSkill

-(id)initWithLevel:(int)level {
    if (self = [super init]) {
        _isActivated = NO;
        _skillType = OrbSkillTypeOthers;
        _level = level;
    }
    return self;
}

-(BOOL)isActivated:(NSDictionary *)orbInfo {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
    return NO;
}

@end
