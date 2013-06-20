//
//  AIStateHeroIdle.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/27.
//
//

#import "AIStateHeroIdle.h"
#import "AIStateHeroWalk.h"
#import "AIStateHeroAttack.h"

#import "MovePathComponent.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "Entity.h"

@implementation AIStateHeroIdle

-(NSString *)name {
    return @"Hero Goofing off";
}

-(void)updateEntity:(Entity *)entity {
    
    MovePathComponent *pathCom = (MovePathComponent *)[entity getComponentOfClass:[MovePathComponent class]];
    if (pathCom.path.count > 0) {
        [self changeState:[[AIStateHeroWalk alloc] init] forEntity:entity];
        return;
    }
    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfClass:[ActiveSkillComponent class]];
    ActiveSkill *skill = [skillCom.skills objectForKey:@"attack"];
    
    if (!skill) {
        return;
    }
    
    // TODO: Other condition to use skill
    if ([skill checkRange]) {
        [self changeState:[[AIStateHeroAttack alloc] init] forEntity:entity];
        return;
    }
}

@end
