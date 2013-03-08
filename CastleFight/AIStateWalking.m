//
//  AIStateMass.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/25/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "AIStateWalking.h"
#import "BaseAI.h"
#import "HelloWorldLayer.h"
#import "AIStateAttack.h"
#import "Character.h"
@implementation AIStateWalking

- (NSString *)name {
    return @"Walking";
}

- (void)enter:(BaseAI *)ai {
    
}

- (void)execute:(BaseAI *)ai {
    // Check if should change state
    NSArray* enemies= [ai.character.skill checkTarget];
    if (enemies.count > 0) {
        [ai changeState:[[AIStateAttack alloc] init]];
        return;
    } else {
        //to do: change back to ai init?
        if (ai.character.player == 1) {
            ai.targetPoint=ccp(1,0);
        }else
        {
            ai.targetPoint=ccp(-1,0);
        }
        [ai.character setMoveDirection:ai.targetPoint];
        return;
    }
}

- (void)exit:(BaseAI *)ai {
    
}

@end
