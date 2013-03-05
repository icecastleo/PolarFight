//
//  SimpleAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/4.
//
//

#import "SimpleAI.h"
#import "Character.h"
@implementation SimpleAI

-(void) AIUpdate{
    if(aiState == Walking)
    {
        if (character.player == 1) {
            [character setMoveDirection:ccp(1, 0)];
        } else {
            [character setMoveDirection:ccp(-1, 0)];
        }
    }
}

@end
