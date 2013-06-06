//
//  AttributeBonusComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/6.
//
//

#import "AttributeBonusComponent.h"
#import "Attribute.h"

@implementation AttributeBonusComponent

-(id)init {
    if (self = [super init]) {
        _attributes = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
//    [super setEntity:entity];
//    for (PassiveSkill *skill in self.skills.allValues) {
//        skill.owner = entity;
//    }
}

-(void)receiveEvent:(EventType)type Message:(id)message {
//    for (PassiveSkill *passiveSkill in self.skills.allValues) {
//        [passiveSkill checkEvent:type];
//        [passiveSkill activeEffect];
//    }
}

@end
