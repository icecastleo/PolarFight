//
//  AIStateMass.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/25/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "AIStateWalk.h"
#import "AIStateAttack.h"
#import "TeamComponent.h"
#import "MoveComponent.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "Entity.h"

#import "AIComponent.h"

@implementation AIStateWalk

-(NSString *)name {
    return @"Walk";
}

-(void)enter:(Entity *)entity {
    TeamComponent *teamCom = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
    
    if (teamCom.team == kPlayerTeam) {
        moveCom.velocity = ccp(1, 0);
    } else {
        moveCom.velocity = ccp(-1, 0);
    }
}

-(void)updateEntity:(Entity *)entity {    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
    
    //test skill
    AIComponent *aiCom = (AIComponent *)[entity getComponentOfName:[AIComponent name]];
    
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
            } else if(removeIndex < 0){
                // not found
                break;
            } else {
                [sortSkillKey removeObjectAtIndex:removeIndex];
                count2 = sortSkillKey.count;
                skill = nil;
                skillName = nil;
            }
            
        }
    } else {
        skillName = [aiCom.skillProbability objectForKey:[aiCom.sortSkillProbabilities objectAtIndex:0]];
        skill = [skillCom.skills objectForKey:skillName];
    }
    NSAssert(skill != nil, @"you forgot to make this skill.");
    
    // TODO: Other condition to use skill
    if ([skill checkRange]) {
        [self changeState:[[AIStateAttack alloc] init] forEntity:entity];
        return;
    }
}

-(void)exit:(Entity *)entity {
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
    moveCom.velocity = ccp(0, 0);
}

@end
