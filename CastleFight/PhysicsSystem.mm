//
//  PhysicsSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/9.
//
//

#import "PhysicsSystem.h"
#import "GLES-Render.h"
#import "MyContactListener.h"

@implementation PhysicsDebugDrawLayer

-(id)initWithPhysicsWorld:(b2World *)aWorld {
    if (self = [super init]) {
        world = aWorld;
    }
    return self;
}

-(void)draw {
	[super draw];
	ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
	kmGLPushMatrix();
	world->DrawDebugData();
	kmGLPopMatrix();
}

@end

@interface PhysicsSystem() {
    GLESDebugDraw *debugDraw;
}

@end


@implementation PhysicsSystem

const static int kVelocityIterations = 8;
const static int kPositionIterations = 3;

-(id)init {
    if (self = [super init]) {
        // Set default gravity
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        
        // Create b2 world
        _world = new b2World(gravity);
        _world->SetAllowSleeping(false);
        
        // Create contact listener
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        debugDraw = new GLESDebugDraw(PTM_RATIO);
        _world->SetDebugDraw(debugDraw);
        
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        //		flags += b2Draw::e_jointBit;
        //		flags += b2Draw::e_aabbBit;
        //		flags += b2Draw::e_pairBit;
        //		flags += b2Draw::e_centerOfMassBit;
        
        debugDraw->SetFlags(flags);
        _debugLayer = [[PhysicsDebugDrawLayer alloc] initWithPhysicsWorld:_world];
        
//        [self addGroundBody];
    }
    return self;
}

-(void)dealloc {
    [_debugLayer removeFromParentAndCleanup:YES];
    delete _world;
    delete _contactListener;
    delete debugDraw;
}

-(void)addGroundBody {
    CGSize s = [[CCDirector sharedDirector] winSize];
    
    // Define the ground body.
	b2BodyDef groundBodyDef;
	groundBodyDef.position.Set(0, 0); // bottom-left corner
	
	// Call the body factory which allocates memory for the ground body
	// from a pool and creates the ground box shape (also from a pool).
	// The body is also added to the world.
	b2Body* groundBody = _world->CreateBody(&groundBodyDef);
	
	// Define the ground box shape.
	b2EdgeShape groundBox;
	
	// bottom
	groundBox.Set(b2Vec2(0,0), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// top
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO));
	groundBody->CreateFixture(&groundBox,0);
	
	// left
	groundBox.Set(b2Vec2(0,s.height/PTM_RATIO), b2Vec2(0,0));
	groundBody->CreateFixture(&groundBox,0);
	
	// right
	groundBox.Set(b2Vec2(s.width/PTM_RATIO,s.height/PTM_RATIO), b2Vec2(s.width/PTM_RATIO,0));
	groundBody->CreateFixture(&groundBox,0);
}

-(void)update:(float)delta {
    _world->Step(delta, kVelocityIterations, kPositionIterations);
}

-(NSArray *)getCollisionEntitiesWithBody:(b2Body *)body {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    std::vector<MyContact>::iterator pos;
    for(pos = _contactListener->contacts.begin(); pos != _contactListener->contacts.end(); ++pos) {
        MyContact contact = *pos;
        
        // Get the box2d bodies for each object
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        
        if (bodyA == body) {
            Entity *entity = (__bridge Entity *)bodyB->GetUserData();
            [ret addObject:entity];
        } else if (bodyB == body) {
            Entity *entity = (__bridge Entity *)bodyA->GetUserData();
            [ret addObject:entity];
        }
    }
    return ret;
}

@end
