//
//  AIStateRush.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/25/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "AIStateAttack.h"
#import "BaseAI.h"
#import "Character.h"
#import "HelloWorldLayer.h"
#import "AIStateWalking.h"

@implementation AIStateAttack

- (NSString *)name {
    return @"Attack";
}

- (void)enter:(BaseAI *)ai {
}

- (void)execute:(BaseAI *)ai {
    // Check if should change state
    NSArray* enemies= [ai.character.skill checkTarget];
    if (enemies.count > 0) {
        [ai.character useSkill];
        return;
    } else{
        [ai changeState:[[AIStateWalking alloc] init]];
        return;
    }

}

@end
