//
//  AIStateHeroWalk.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/27.
//
//

#import "AIStateHeroWalk.h"
#import "AIStateHeroIdle.h"
#import "AIStateHeroAttack.h"

#import "RenderComponent.h"
#import "MovePathComponent.h"
#import "TeamComponent.h"
#import "MoveComponent.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "Entity.h"

@implementation AIStateHeroWalk
- (NSString *)name {
    return @"Hero Walking";
}

- (void)updateEntity:(Entity *)entity {
    
    MovePathComponent *pathCom = (MovePathComponent *)[entity getComponentOfClass:[MovePathComponent class]];
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    
    CGPoint currentPosition = renderCom.position;
    CGPoint nextPosition = [pathCom nextPositionFrom:currentPosition];
    CGPoint diff = ccpSub(nextPosition, currentPosition);
    
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
    
    moveCom.velocity = ccpNormalize(diff);
    
    ActiveSkillComponent *skillCom = (ActiveSkillComponent *)[entity getComponentOfClass:[ActiveSkillComponent class]];
    ActiveSkill *skill = [skillCom.skills objectForKey:@"attack"];
    
    if (!skill) {
        return;
    }
    
    // TODO: Other condition to use skill
    if (pathCom.path.count == 0 && [skill checkRange]) {
        [self changeState:[[AIStateHeroAttack alloc] init] forEntity:entity];
        return;
    }
    
    //TODO: change To idle
    if (pathCom.path.count == 0) {
        [self changeState:[[AIStateHeroIdle alloc] init] forEntity:entity];
        return;
    }
}

- (void)exit:(Entity *)entity {
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
    moveCom.velocity = ccp(0, 0);
}

@end
