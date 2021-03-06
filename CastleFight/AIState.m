//
//  AIState.m
//  CastleFight
//
//  Created by 陳 謙 on 13/3/7.
//
//

#import "AIState.h"
#import "Entity.h"
#import "AIComponent.h"

@implementation AIState

-(NSString *)name {
    return @"unknown";
}

-(void)enter:(Entity *)entity {
    
}

-(void)exit:(Entity *)entity {
    
}

-(void)updateEntity:(Entity *)entity {
    
}

-(void)changeState:(AIState *)state forEntity:(Entity *)entity {
    AIComponent *ai = (AIComponent *)[entity getComponentOfName:[AIComponent name]];
    
    NSAssert(ai.state == self, @"Why not??");
    
    [ai.state exit:entity];
    ai.state = state;
    [ai.state enter:entity];
}

@end
