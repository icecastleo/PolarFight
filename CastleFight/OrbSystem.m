//
//  OrbSystem.m
//  CastleFight
//
//  Created by  DAN on 13/8/15.
//
//

#import "OrbSystem.h"
#import "OrbBoardComponent.h"
#import "OrbComponent.h"
#import "RenderComponent.h"

@implementation OrbSystem

-(void)update:(float)delta {
    
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfClass:[OrbBoardComponent class]]) {
    }
}

@end
