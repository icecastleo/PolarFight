//
//  PhysicsSystem.h
//  CastleFight
//
//  Created by 朱 世光 on 13/7/9.
//
//

#import "System.h"

CLS_DEF(b2World);
CLS_DEF(b2Body);
CLS_DEF(MyContactListener);

@interface PhysicsDebugDrawLayer:CCLayer {
    b2World *world;
}

-(id)initWithPhysicsWorld:(b2World *)aWorld;

@end

@interface PhysicsSystem : NSObject

@property (readonly) b2World *world;
@property (readonly) MyContactListener *contactListener;
@property (readonly) PhysicsDebugDrawLayer *debugLayer;

-(void)update:(float)delta;
-(NSArray *)getCollisionEntitiesWithBody:(b2Body *)body;

@end
