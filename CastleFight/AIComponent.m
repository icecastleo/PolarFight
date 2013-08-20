//
//  AIComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "AIComponent.h"
#import "AIState.h"

@interface AIComponent() {
    AIState *tempState;
    int sumOfZeroProbabilitySkill;
}

@end

@implementation AIComponent

+(NSString *)name {
    static NSString *name = @"AIComponent";
    return name;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if ((self = [super init])) {
        _state = [[NSClassFromString([dic objectForKey:@"state"]) alloc] init];
        [self setSkillTable:[dic objectForKey:@"skillProbability"]];
        sumOfZeroProbabilitySkill = 0;
    }
    return self;
}

-(id)initWithState:(AIState *)state {
    if ((self = [super init])) {
        self.state = state;
    }
    return self;
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    [_state enter:entity];
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventPrepare || type == kEntityEventDead) {
        [_state exit:self.entity];
        tempState = _state;
        _state = nil;
    } else if (type == kEntityEventReady || type == kEntityEventRevive) {
        _state = tempState;
        tempState = nil;
        [_state enter:self.entity];
    }
    
    if ([_state respondsToSelector:@selector(receiveEvent:Message:)]) {
        [_state receiveEvent:type Message:message];
    }
}

-(void)dealloc {
    [_state exit:self.entity];
}

-(void)setSkillTable:(NSDictionary *)dic {
    NSMutableDictionary *adjustDic = [[NSMutableDictionary alloc] initWithCapacity:dic.count];
    
    for(NSString *skillName in dic.allKeys) {
        NSNumber *value = [dic objectForKey:skillName];
        int probability = value.intValue;
        if (probability > 0) {
            _sumOfProbability += probability;
            [adjustDic setObject:skillName forKey:[NSString stringWithFormat:@"%d",self.sumOfProbability]];
        }else {
            sumOfZeroProbabilitySkill += 1;
            [adjustDic setObject:skillName forKey:[NSString stringWithFormat:@"%d",sumOfZeroProbabilitySkill*-1]];
        }
    }

    _sortSkillProbabilities = [adjustDic.allKeys sortedArrayUsingComparator:^(NSString *str1, NSString *str2) {
        return [str1 compare:str2 options:NSNumericSearch];
    }];
    
    _skillProbability = adjustDic;
}

-(NSString *)getSkillNameFromNumber:(int)number {
    NSAssert(number < self.sumOfProbability, @"Skill only happens if the number is smaller than sum of probability.");
    
    int count = self.sortSkillProbabilities.count - 1;
    for (int i = 0; i < count ; i++) {
        NSString *value = [self.sortSkillProbabilities objectAtIndex:i];
        NSString *nextValue = [self.sortSkillProbabilities objectAtIndex:i+1];
        if (number >= value.intValue && number < nextValue.intValue) {
            return [self.skillProbability objectForKey:nextValue];
        }
    }
    return nil;
}

@end