//
//  AIStateHeroAttack.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/20.
//
//

#import "AIStateHeroAttack.h"
#import "AIStateHeroWalk.h"
#import "AIStateHeroIdle.h"

#import "MovePathComponent.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "Entity.h"
#import "AIComponent.h"

@implementation AIStateHeroAttack

- (NSString *)name {
    return @"Hero Attacking";
}

- (void)updateEntity:(Entity *)entity {
    
    MovePathComponent *pathCom = (MovePathComponent *)[entity getComponentOfName:[MovePathComponent name]];
    if (pathCom.path.count > 0) {
        [self changeState:[[AIStateHeroWalk alloc] init] forEntity:entity];
        return;
    }
    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
    
    //test skill
    AIComponent *aiCom = (AIComponent *)[entity getComponentOfName:[AIComponent name]];
    
    ActiveSkill *skill = nil;
    NSString *skillName = nil;
    
    if (skillCom.skills.count > 1) {
        NSMutableDictionary *skillDic = [[NSMutableDictionary alloc] initWithDictionary:aiCom.skillProbabilityDic];
        int count = skillDic.count;
        int ratioSum = 0;
        
        for (int i=0; i<count; i++) {
            for (NSNumber *ratio in skillDic.allValues) {
                ratioSum += ratio.intValue;
            }
            int random = arc4random_uniform(ratioSum)+1;
            
            for (NSString *key in skillDic.allKeys) {
                NSNumber *ratio = [skillDic objectForKey:key];
                random -= ratio.intValue;
                if (random <= 0) {
                    skillName = key;
                    break;
                }
            }
            
            if (!skillName) {
                skillName = [skillDic.allKeys objectAtIndex:0];
            }
            
            skill = [skillCom.skills objectForKey:skillName];
            if (skill.canActive) {
                break;
            } else {
                [skillDic removeObjectForKey:skillName];
                if (skillDic.count == 0) {
                    break;
                }
                skill = nil;
                skillName = nil;
            }
        }
    } else {
        skillName = [aiCom.skillProbabilityDic.allKeys objectAtIndex:0];
        skill = [skillCom.skills objectForKey:skillName];
    }
    NSAssert(skill != nil, @"you forgot to make this skill.");
    
    if (!skillCom.activeKey) {
        if ([skill checkRange]) {
            skillCom.activeKey = skillName;
        } else {
            if (!skillCom.currentSkill) {
                [self changeState:[[AIStateHeroIdle alloc] init] forEntity:entity];
                return;
            }
        }
    }
}

@end
