//
//  AIStateHeroIdle.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/27.
//
//

#import "AIStateHeroIdle.h"
#import "AIStateHeroWalk.h"
#import "HeroAI.h"
#import "Character.h"
#import "ActiveSkill.h"
#import "Character.h"
#import "AIState.h"

@implementation AIStateHeroIdle

-(NSString *)name {
    return @"HeroWalking";
}

-(void)enter:(BaseAI *)ai {

}

-(void)execute:(BaseAI *)ai {

    if(fabs(ccpSub(ai.targetPoint, ai.character.position).x)>1)
    {
        [ai changeState:[[AIStateHeroWalk alloc] init]];
    }
}

-(void)exit:(BaseAI *)ai {
    
}
@end
