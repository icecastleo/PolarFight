//
//  MinionAIStatePanic.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/27.
//
//

#import "MinionAIStatePanic.h"
#import "MoveComponent.h"
#import "ActiveSkillComponent.h"
#import "MinionAIStateAttack.h"

@interface MinionAIStatePanic() {
    int count;
    
    MoveComponent *move;
    ActiveSkillComponent *skills;
}
@end

@implementation MinionAIStatePanic

-(void)enter:(Entity *)entity {
    move = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
    skills = (ActiveSkillComponent *)[entity getComponentOfName:[ActiveSkillComponent name]];
    
    count = 15;
    move.velocity = ccp(CCRANDOM_MINUS1_1(), CCRANDOM_MINUS1_1());
}

-(void)updateEntity:(Entity *)entity {
    count--;
    
    if (count == 0) {
        count = 15 + arc4random_uniform(10);
        
        // add panic component and show panic status?
        move.velocity = ccp(CCRANDOM_MINUS1_1(), CCRANDOM_MINUS1_1());
        
    } else if (count <= 10) {
        if (count == 10) {
            move.velocity = CGPointZero;
        }
        
        ActiveSkill *skill = [skills.skills objectForKey:@"attack1"];
        
        if ([skill checkRange]) {
            [self changeState:[[MinionAIStateAttack alloc] initWithGeneral:self.general] forEntity:entity];
        }
    }
}

-(void)exit:(Entity *)entity {
    move.velocity = CGPointZero;
}

@end
