//
//  PhysicsRoot.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/15.
//
//

#import "PhysicsRoot.h"

@implementation PhysicsRoot

-(void)setDirection:(DirectionComponent *)direction {
    _direction = direction;
    [self scheduleUpdate];
}

-(void)update:(ccTime)delta {
    self.rotation = _direction.cocosDegrees;
}

@end
