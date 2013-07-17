//
//  PhysicsNode.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/12.
//
//

#import "PhysicsNode.h"
#import "CGPointExtension.h"
#import "Box2D.h"

@implementation PhysicsNode

-(id)init {
    if (self = [super init]) {
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta {
    // Physics body follow node

//    // Can not update without a parent!
//    CGPoint position;
//    
//    if (self.parent) {
//        position = [self.parent convertToWorldSpace:self.position];
//    } else {
//        position = self.position;
//    }
    
    CGPoint position = [self.parent convertToWorldSpace:self.position];
    
    if (_direction) {
        // Phycics body's radians control by direction
        float radians = _direction.radians;
        _b2Body->SetTransform(b2Vec2(position.x / _PTMRatio, position.y / _PTMRatio), radians);
    } else {
        _b2Body->SetTransform(b2Vec2(position.x / _PTMRatio, position.y / _PTMRatio), _b2Body->GetAngle());
    }
}

@end
