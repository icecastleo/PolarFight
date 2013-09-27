//
//  GeneralAIStateAttack.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/26.
//
//

#import "GeneralAIStateAttack.h"
#import "ActiveSkillComponent.h"
#import "GeneralAIStateWalk.h"

@interface GeneralAIStateAttack() {
    ActiveSkillComponent *skills;
}

@end

@implementation GeneralAIStateAttack

-(void)enter:(Entity *)entity {
    skills = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
}

-(void)updateEntity:(Entity *)entity {
    ActiveSkill *skill = [skills.skills objectForKey:@"attack1"];
    
    if ([skill checkRange]) {
        skills.activeKey = @"attack1";
    } else {

        [self changeState:[[GeneralAIStateWalk alloc] init] forEntity:entity];
    }
}

@end
