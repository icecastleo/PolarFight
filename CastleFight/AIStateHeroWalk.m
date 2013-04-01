//
//  AIStateHeroWalk.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/27.
//
//

#import "AIStateHeroWalk.h"
#import "HeroAI.h"
#import "Character.h"
#import "ActiveSkill.h"
#import "Character.h"
#import "AIState.h"
#import "AIStateHeroIdle.h"
#import "MapCamera.h"
@implementation AIStateHeroWalk
- (NSString *)name {
    return @"HeroWalking";
}

- (void)enter:(BaseAI *)ai {
    
}

- (void)execute:(BaseAI *)ai {
    // Check if should change state
    
    
    CGPoint subPoint = ccpSub(ai.targetPoint, ai.character.position);
    if(fabs(subPoint.x)>3)
    {
        
        if(subPoint.x>0)
            [ai.character setMoveDirection:ccp(1,0)];
        else
            [ai.character setMoveDirection:ccp(-1,0)];
        
    }
    else
    {
        [ai.character setMoveDirection:ccp(0,0)];
        [ai changeState:[[AIStateHeroIdle alloc] init]];
        
        ai.targetPoint=ai.character.position;
        
    }
    
    
    
    return;
}


- (void)exit:(BaseAI *)ai {
    
}
@end
