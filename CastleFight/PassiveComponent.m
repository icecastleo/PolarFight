//
//  PassiveComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/31.
//
//

#import "PassiveComponent.h"
#import "PassiveSkill.h"

@implementation PassiveComponent

+(NSString *)name {
    static NSString *name = @"PassiveComponent";
    return name;
}

-(id)init {
    if (self = [super init]) {
        _skills = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    
    for (PassiveSkill *skill in self.skills.allValues) {
        skill.owner = entity;
    }
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    for (PassiveSkill *passiveSkill in self.skills.allValues) {
        [passiveSkill checkEvent:type Message:message];
    }
}

@end
