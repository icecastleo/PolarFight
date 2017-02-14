//
//  PhysicsSprite.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/15.
//
//

#import "PhysicsSprite.h"
#import "CGPointExtension.h"
#import "Box2D.h"

@implementation PhysicsSprite

-(id)init {
    if (self = [super init]) {
        [self scheduleUpdate];
    }
    return self;
}

-(void)update:(ccTime)delta {
    // Physics body control sprite
    b2Vec2 pos  = _b2Body->GetPosition();
    
    float x = pos.x * _PTMRatio;
    float y = pos.y * _PTMRatio;
    
//    // Can not update without a parent!
//    if (self.parent) {
//        self.position = [self.parent convertToNodeSpace:ccp(x, y)];
//    } else {
//        self.position = ccp(x, y);
//    }
    
    self.position = [self.parent convertToNodeSpace:ccp(x, y)];

    if (_direction) {
        _direction.velocity = ccpForAngle(_b2Body->GetAngle());
        self.rotation = _direction.cocosDegrees;
    }
}

-(void)dealloc {
    // FIXME: It will caused bug.
//    _b2Body->GetWorld()->DestroyBody(_b2Body);
}


@end
