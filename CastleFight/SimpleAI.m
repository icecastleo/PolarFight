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

    if(aiState==Walking)
    {
        [character moveBy:ccp(100, 100)];
    }

}

@end
