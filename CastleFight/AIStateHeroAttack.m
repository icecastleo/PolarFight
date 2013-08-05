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

@implementation AIStateHeroAttack

- (NSString *)name {
    return @"Hero Attacking";
}

- (void)updateEntity:(Entity *)entity {
    
    MovePathComponent *pathCom = (MovePathComponent *)[entity getComponentOfClass:[MovePathComponent class]];
    if (pathCom.path.count > 0) {
        [self changeState:[[AIStateHeroWalk alloc] init] forEntity:entity];
        return;
    }
    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfClass:[ActiveSkillComponent class]];
    
    //test skill
    ActiveSkill *skill;
    NSString *skillName = nil;
    
    if (skillCom.skills.count > 1) {
        NSMutableArray *sortSkillKey = [NSMutableArray arrayWithArray:skillCom.sortSkillProbabilities];
        
        int count = sortSkillKey.count;
        int count2 = count;
        
        for (int i=0; i<count; i++) {
            int random = arc4random_uniform(skillCom.sumOfProbability);
            //FIXME: edit it to skill.
            int removeIndex = -1;
            
            for (int j=1; j<count2; j++) {
                NSString *preValue = [sortSkillKey objectAtIndex:j-1];
                NSString *value = [sortSkillKey objectAtIndex:j];
                if (random >= preValue.intValue && random < value.intValue) {
                    skillName = [skillCom.skillNames objectForKey:value];
                    removeIndex = j;
                    break;
                }
            }
            
            if (!skillName) {
                skillName = [skillCom.skillNames objectForKey:[sortSkillKey objectAtIndex:0]];
            }
            
            skill = [skillCom.skills objectForKey:skillName];
            if (skill.canActive) {
                break;
            }else if(removeIndex < 0){
                // not found
                break;
            }else {
                [sortSkillKey removeObjectAtIndex:removeIndex];
                count2 = sortSkillKey.count;
                skill = nil;
                skillName = nil;
            }
            
        }
    }else {
        skillName = [skillCom.skillNames objectForKey:[skillCom.sortSkillProbabilities objectAtIndex:0]];
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
