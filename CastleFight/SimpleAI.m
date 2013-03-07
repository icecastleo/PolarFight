//
//  SimpleAI.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/4.
//
//

#import "SimpleAI.h"
#import "Character.h"
#import "ActiveSkill.h"
#import "Character.h"
@implementation SimpleAI

-(void) AIUpdate{
    if(aiState == Walking)
    {
        if (character.player == 1) {
            NSArray* target= [character.skill checkTarget];
            if(target.count>0)
            {
                [character useSkill];
                
                //aiState=Battleing;
            }else{
            [character setMoveDirection:ccp(10, 0)];
            }
        } else {
            [character setMoveDirection:ccp(-10, 0)];
        }
    }
}

@end
