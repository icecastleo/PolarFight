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

@implementation AIStateWalk

-(NSString *)name {
    return @"Walk";
}

-(void)enter:(Entity *)entity {
    TeamComponent *teamCom = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
        
    if (teamCom.team == 1) {
        moveCom.velocity = ccp(1, 0);
    } else {
        moveCom.velocity = ccp(-1, 0);
    }
}

-(void)updateEntity:(Entity *)entity delta:(float)delta {
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfClass:[ActiveSkillComponent class]];
    ActiveSkill *skill = [skillCom.skills objectForKey:@"attack"];
    
    if (!skill) {
        return;
    }

    // TODO: Other condition to use skill
    if ([skill checkRange]) {
        [self changeState:[[AIStateAttack alloc] init] forEntity:entity];
        return;
    }
}

-(void)exit:(Entity *)entity {
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
    moveCom.velocity = ccp(0, 0);
}

@end
