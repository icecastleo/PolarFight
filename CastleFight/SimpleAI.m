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
#import "AIState.h"
@implementation SimpleAI

-(void) AIUpdate{
    [_currentState execute:self];
    
}

@end
