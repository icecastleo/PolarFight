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
    
    //TODO: Other conditions to use Active Skill.
    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfClass:[ActiveSkillComponent class]];
    ActiveSkill *skill = [skillCom.skills objectForKey:@"attack"];
    
    if (!skill) {
        return;
    }
    
    if (!skillCom.activeKey) {
        if ([skill checkRange]) {
            skillCom.activeKey = @"attack";
        } else {
            if (!skillCom.currentSkill) {
                [self changeState:[[AIStateHeroIdle alloc] init] forEntity:entity];
                return;
            }
        }
    }
    
}

@end
