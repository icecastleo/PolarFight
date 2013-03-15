//
//  AIStateCastleWaiting.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/13.
//
//

#import "AIStateCastleWaiting.h"
#import "EnemyAI.h"
@implementation AIStateCastleWaiting

- (void)execute:(BaseAI *)ai {
    // Check if should change state
    
    //examine once a sec
    if(CACurrentMediaTime()>nextDecisionTime)
        [self examineNextMonster:ai];
    
}

-(void) examineNextMonster:(BaseAI *)ai
{
    
    //EnemyAI *a = (EnemyAI*)ai;
    CCLOG(@"test");
    nextDecisionTime=CACurrentMediaTime()+1;
    
}

@end
