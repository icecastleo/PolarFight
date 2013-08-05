//
//  SkillComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "ActiveSkillComponent.h"

@interface ActiveSkillComponent()
{
    int sumOfZeroProbabilitySkill;
}

@end

@implementation ActiveSkillComponent

-(id)init {
    if (self = [super init]) {
        _skills = [[NSMutableDictionary alloc] init];
        _skillNames = [[NSDictionary alloc] init];
        _sumOfProbability = 0;
        sumOfZeroProbabilitySkill = 0;
    }
    return self;
}

-(void)setActiveKey:(NSString *)activeKey {
    if (_activeKey && activeKey) {
        return;
    }
    _activeKey = activeKey;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    
    for (ActiveSkill *skill in _skills.allValues) {
        skill.owner = entity;
    }
}

-(void)addSkillName:(NSString *)skillName andProbability:(int)probability {
    
    NSMutableDictionary *adjustSkills = [[NSMutableDictionary alloc] initWithDictionary:self.skills];
    [adjustSkills setObject:[[NSClassFromString(skillName) alloc] init] forKey:skillName];
    _skills = adjustSkills;
    
    NSMutableDictionary *adjustDic = [[NSMutableDictionary alloc] initWithDictionary:self.skillNames];
    
    if (probability > 0) {
        _sumOfProbability += probability;
        [adjustDic setObject:skillName forKey:[NSString stringWithFormat:@"%d",self.sumOfProbability]];
    }else {
        sumOfZeroProbabilitySkill += 1;
        [adjustDic setObject:skillName forKey:[NSString stringWithFormat:@"%d",sumOfZeroProbabilitySkill*-1]];
    }
    
    _sortSkillProbabilities = [adjustDic.allKeys sortedArrayUsingComparator:^(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:NSNumericSearch];
    }];
    
    _skillNames = adjustDic;
}

-(NSString *)getSkillNameFromNumber:(int)number {
    NSAssert(number < self.sumOfProbability, @"Skill only happens if the number is smaller than sum of probability.");
    
    int count = self.sortSkillProbabilities.count - 1;
    for (int i = 0; i < count ; i++) {
        NSString *value = [self.sortSkillProbabilities objectAtIndex:i];
        NSString *nextValue = [self.sortSkillProbabilities objectAtIndex:i+1];
        if (number >= value.intValue && number < nextValue.intValue) {
            return [self.skillNames objectForKey:nextValue];
        }
    }
    return nil;
}

@end
