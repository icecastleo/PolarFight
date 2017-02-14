//
//  AIStateHeroWalk.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/27.
//
//

#import "AIStateHeroWalk.h"
#import "AIStateHeroIdle.h"
#import "AIStateHeroAttack.h"

#import "RenderComponent.h"
#import "MovePathComponent.h"
#import "TeamComponent.h"
#import "MoveComponent.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "Entity.h"
#import "AIComponent.h"

@implementation AIStateHeroWalk
- (NSString *)name {
    return @"Hero Walking";
}

- (void)updateEntity:(Entity *)entity {
    
    MovePathComponent *pathCom = (MovePathComponent *)[entity getComponentOfName:[MovePathComponent name]];
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    
    CGPoint currentPosition = renderCom.position;
    CGPoint nextPosition = [pathCom nextPositionFrom:currentPosition];
    CGPoint diff = ccpSub(nextPosition, currentPosition);
    
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
    moveCom.velocity = diff;
    
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
    
    // TODO: Other condition to use skill
    if (pathCom.path.count == 0 && [skill checkRange]) {
        [self changeState:[[AIStateHeroAttack alloc] init] forEntity:entity];
        return;
    }
    
    //TODO: change To idle
    if (pathCom.path.count == 0) {
        [self changeState:[[AIStateHeroIdle alloc] init] forEntity:entity];
        return;
    }
}

- (void)exit:(Entity *)entity {
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
    moveCom.velocity = ccp(0, 0);
}

@end
