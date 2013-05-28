//
//  AISystem.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "AISystem.h"
#import "AIState.h"
#import "AIComponent.h"

@implementation AISystem

-(void)update:(float)delta {
    t += delta;
    
    if (t >= kAISystemUpdateInterval) {
        t -= kAISystemUpdateInterval;
    } else {
        return;
    }
    
    NSArray * entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[AIComponent class]];
    
    for (Entity *entity in entities) {
        AIComponent * ai = (AIComponent *)[entity getComponentOfClass:[AIComponent class]];
        [ai.state updateEntity:entity];
    }
}

@end
