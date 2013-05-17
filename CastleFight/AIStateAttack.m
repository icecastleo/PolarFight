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

@implementation AIStateAttack

-(NSString *)name {
    return @"Attack";
}

-(void)updateEntity:(Entity *)entity delta:(float)delta {
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfClass:[ActiveSkillComponent class]];
    ActiveSkill *skill = [skillCom.skills objectForKey:@"attack"];
    
    if (!skill) {
        return;
    }
    
    if (!skillCom.activeKey) {
        if ([skill checkRange]) {
            skillCom.activeKey = @"attack";
        } else {
            [self changeState:[[AIStateWalk alloc] init] forEntity:entity];
            return;
        }
    }
}

@end
