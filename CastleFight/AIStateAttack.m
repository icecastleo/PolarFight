//
//  AIStateRush.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/25/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "AIStateAttack.h"
#import "AIStateWalk.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "Entity.h"

#import "AIComponent.h"

@implementation AIStateAttack

-(NSString *)name {
    return @"Attack";
}

-(void)updateEntity:(Entity *)entity {
    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
    
    //test skill
    AIComponent *aiCom = (AIComponent *)[entity getComponentOfName:[AIComponent name]];
    
//    ActiveSkill *skill = nil;
//    NSString *skillName = nil;
//    
//    if (skillCom.skills.count > 1) {
//        NSMutableDictionary *skillDic = [[NSMutableDictionary alloc] initWithDictionary:aiCom.skillProbabilityDic];
//        int count = skillDic.count;
//        int ratioSum = 0;
//        
//        for (int i=0; i<count; i++) {
//            for (NSNumber *ratio in skillDic.allValues) {
//                ratioSum += ratio.intValue;
//            }
//            int random = arc4random_uniform(ratioSum)+1;
//            
//            for (NSString *key in skillDic.allKeys) {
//                NSNumber *ratio = [skillDic objectForKey:key];
//                random -= ratio.intValue;
//                if (random <= 0) {
//                    skillName = key;
//                    break;
//                }
//            }
//            
//            if (!skillName) {
//                skillName = [skillDic.allKeys objectAtIndex:0];
//            }
//            
//            skill = [skillCom.skills objectForKey:skillName];
//            if (skill.canActive) {
//                break;
//            } else {
//                [skillDic removeObjectForKey:skillName];
//                if (skillDic.count == 0) {
//                    break;
//                }
//                skill = nil;
//                skillName = nil;
//            }
//        }
//    } else {
//        skillName = [aiCom.skillProbabilityDic.allKeys objectAtIndex:0];
//        skill = [skillCom.skills objectForKey:skillName];
//    }
//    NSAssert(skill != nil, @"you forgot to make this skill.");
//    
//    if (!skillCom.activeKey) {
//        if ([skill checkRange]) {
//            skillCom.activeKey = skillName;
//        } else {
//            if (!skillCom.currentSkill) {
//                [self changeState:[[AIStateWalk alloc] init] forEntity:entity];
//                return;
//            }
//        }
//    }

    ActiveSkill *skill = [skillCom.skills objectForKey:@"attack1"];
    
    if ([skill checkRange]) {
        skillCom.activeKey = @"attack1";
    } else {
        [self changeState:[[AIStateWalk alloc] init] forEntity:entity];
    }
}

@end
