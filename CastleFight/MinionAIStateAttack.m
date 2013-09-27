//
//  MinionAIStateAttack.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/26.
//
//

#import "MinionAIStateAttack.h"
#import "ActiveSkillComponent.h"
#import "MinionAIStateWalk.h"

@interface MinionAIStateAttack() {
    ActiveSkillComponent *skills;
}

@end

@implementation MinionAIStateAttack

-(void)enter:(Entity *)entity {
    skills = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
}

-(void)updateEntity:(Entity *)entity {
    ActiveSkill *skill = [skills.skills objectForKey:@"attack1"];
    
    if ([skill checkRange]) {
        skills.activeKey = @"attack1";
    } else {
        [self changeState:[[MinionAIStateWalk alloc] initWithGeneral:self.general] forEntity:entity];
    }
}

@end
