//
//  AIStateHeroWalk.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/27.
//
//

#import "AIStateHeroWalk.h"
//#import "HeroAI.h"
//#import "AIStateHeroIdle.h"
//#import "MapCamera.h"

#import "AIStateAttack.h"
#import "RenderComponent.h"
#import "MovePathComponent.h"
#import "TeamComponent.h"
#import "MoveComponent.h"
#import "ActiveSkillComponent.h"
#import "ActiveSkill.h"
#import "Entity.h"

@implementation AIStateHeroWalk
- (NSString *)name {
    return @"HeroWalking";
}

- (void)enter:(Entity *)entity {
    
}

- (void)updateEntity:(Entity *)entity {
    
    MovePathComponent *pathCom = (MovePathComponent *)[entity getComponentOfClass:[MovePathComponent class]];
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    
    CGPoint currentPosition = renderCom.sprite.position;
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
    if ([skill checkRange]) {
        [self changeState:[[AIStateAttack alloc] init] forEntity:entity];
        return;
    }
    
    //TODO: change To idle
    if (CGPointEqualToPoint(diff, ccp(0,0))) {
        [self exit:entity];
    }
    
    return;
}


- (void)exit:(Entity *)entity {
    MoveComponent *moveCom = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
    moveCom.velocity = ccp(0, 0);
}

@end
