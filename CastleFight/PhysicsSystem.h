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

@interface PhysicsDebugDrawLayer : CCLayer {
    b2World *world;
}

-(id)initWithPhysicsWorld:(b2World *)aWorld;

@end

@interface PhysicsSystem : System

@property (readonly) b2World *world;
//@property (readonly) PhysicsDebugDrawLayer *debugLayer;

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory;

-(NSArray *)getCollisionEntitiesWithBody:(b2Body *)body;

@end
