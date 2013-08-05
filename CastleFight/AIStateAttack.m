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
    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfClass:[ActiveSkillComponent class]];
    
    //test skill
    AIComponent *aiCom = (AIComponent *)[entity getComponentOfClass:[AIComponent class]];
    
    ActiveSkill *skill;
    NSString *skillName = nil;
    
    if (skillCom.skills.count > 1) {
        NSMutableArray *sortSkillKey = [NSMutableArray arrayWithArray:aiCom.sortSkillProbabilities];
        
        int count = sortSkillKey.count;
        int count2 = count;
        
        for (int i=0; i<count; i++) {
            int random = arc4random_uniform([[sortSkillKey lastObject] intValue]);
            //FIXME: edit it to skill.
            int removeIndex = -1;
            
            for (int j=1; j<count2; j++) {
                NSString *preValue = [sortSkillKey objectAtIndex:j-1];
                NSString *value = [sortSkillKey objectAtIndex:j];
                if (random >= preValue.intValue && random < value.intValue) {
                    skillName = [aiCom.skillProbability objectForKey:value];
                    removeIndex = j;
                    break;
                }
            }
            
            if (!skillName) {
                skillName = [aiCom.skillProbability objectForKey:[sortSkillKey objectAtIndex:0]];
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
        skillName = [aiCom.skillProbability objectForKey:[aiCom.sortSkillProbabilities objectAtIndex:0]];
        skill = [skillCom.skills objectForKey:skillName];
    }
    NSAssert(skill != nil, @"you forgot to make this skill.");
    
    if (!skillCom.activeKey) {
        if ([skill checkRange]) {
            skillCom.activeKey = skillName;
        } else {
            if (!skillCom.currentSkill) {
                [self changeState:[[AIStateWalk alloc] init] forEntity:entity];
                return;
            }
        }
    }

}

@end
