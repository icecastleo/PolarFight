//
//  SkillComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "ActiveSkillComponent.h"

@implementation ActiveSkillComponent

+(NSString *)name {
    static NSString *name = @"ActiveSkillComponent";
    return name;
}

-(id)init {
    if (self = [super init]) {
        _skills = [[NSMutableDictionary alloc] init];
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

@end
