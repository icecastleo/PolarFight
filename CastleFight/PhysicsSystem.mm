//
//  PhysicsSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/9.
//
//

#import "PhysicsSystem.h"
#import "GLES-Render.h"
#import "Box2D.h"
#import <vector>
#import "PhysicsComponent.h"
#import "PhysicsNode.h"

struct MyContact {
    b2Fixture *fixtureA;
    b2Fixture *fixtureB;
    b2WorldManifold *manifold;
    bool operator==(const MyContact& other) const
    {
        return (fixtureA == other.fixtureA) && (fixtureB == other.fixtureB);
    }
    
    MyContact(b2Contact *contact) {
        fixtureA = contact->GetFixtureA();
        fixtureB = contact->GetFixtureB();
        
        manifold = new b2WorldManifold();
        contact->GetWorldManifold(manifold);
    }
};
    
class MyContactListener : public b2ContactListener {
        
    public:
        std::vector<MyContact>contacts;
        
        MyContactListener();
        ~MyContactListener();
        
        virtual void BeginContact(b2Contact* contact);
        virtual void EndContact(b2Contact* contact);
        virtual void PreSolve(b2Contact* contact, const b2Manifold* oldManifold);
        virtual void PostSolve(b2Contact* contact, const b2ContactImpulse* impulse);
};
    
MyContactListener::MyContactListener() : contacts() {
}
    
MyContactListener::~MyContactListener() {
}
    
void MyContactListener::BeginContact(b2Contact* contact) {
    // We need to copy out the data because the b2Contact passed in is reused.
    MyContact myContact = MyContact(contact);
    contacts.push_back(myContact);
}
    
void MyContactListener::EndContact(b2Contact* contact) {
    MyContact myContact = MyContact(contact);
    std::vector<MyContact>::iterator pos;
    pos = std::find(contacts.begin(), contacts.end(), myContact);
    if (pos != contacts.end()) {
        contacts.erase(pos);
    }
}
    
void MyContactListener::PreSolve(b2Contact* contact, const b2Manifold* oldManifold) {
}
    
void MyContactListener::PostSolve(b2Contact* contact, const b2ContactImpulse* impulse) {
}
    
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
    MyContactListener *contactListener;
}

@end

@implementation PhysicsSystem

const static int kVelocityIterations = 8;
const static int kPositionIterations = 3;

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        NSAssert(entityFactory.mapLayer, @"Please provide a map layer for entity and physics!");
        
        // Set default gravity
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        
        // Create b2 world
        _world = new b2World(gravity);
        _world->SetAllowSleeping(false);
        
        // Create contact listener
        contactListener = new MyContactListener();
        _world->SetContactListener(contactListener);
        
        debugDraw = new GLESDebugDraw(PTM_RATIO);
        _world->SetDebugDraw(debugDraw);
        
        uint32 flags = 0;
        flags += b2Draw::e_shapeBit;
        //		flags += b2Draw::e_jointBit;
        //		flags += b2Draw::e_aabbBit;
        //		flags += b2Draw::e_pairBit;
        //		flags += b2Draw::e_centerOfMassBit;
        
        debugDraw->SetFlags(flags);
        PhysicsDebugDrawLayer *debugLayer = [[PhysicsDebugDrawLayer alloc] initWithPhysicsWorld:_world];
    
//        [self addGroundBody];
        
#if kPhisicalDebugDraw
        [entityFactory.mapLayer addChild:debugLayer z:NSIntegerMax];
#endif
    }
    return self;
}

-(void)dealloc {
    delete _world;
    delete contactListener;
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
    NSArray * entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[PhysicsComponent class]];
    
    for (Entity * entity in entities) {
        PhysicsComponent *physics = (PhysicsComponent *)[entity getComponentOfClass:[PhysicsComponent class]];
        DirectionComponent *direction = physics.direction;
        
        // Rotate root
        if (direction) {
            CCNode *directionNode = physics.directionNode;
            
            if (directionNode) {
                int degrees = direction.spriteDirection - directionNode.rotation;
                float radians = CC_DEGREES_TO_RADIANS(degrees);
                direction.velocity = ccpForAngle(radians);
            }
            
            physics.root.rotation = direction.cocosDegrees;
        }
        
        for (PhysicsNode *node in physics.root.children) {
            
            CGPoint position = [node.parent convertToWorldSpace:node.position];
            position = [self.entityFactory.mapLayer convertToNodeSpace:position];
            
            if (direction) {
                // Phycics body's radians control by direction
                float radians = direction.radians;
                node.b2Body->SetTransform(b2Vec2(position.x / PTM_RATIO, position.y / PTM_RATIO), radians);
            } else {
                node.b2Body->SetTransform(b2Vec2(position.x / PTM_RATIO, position.y / PTM_RATIO), node.b2Body->GetAngle());
            }
        }
    }
    
    _world->Step(delta, kVelocityIterations, kPositionIterations);
}

-(NSArray *)getCollisionEntitiesWithBody:(b2Body *)body {
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    
    std::vector<MyContact>::iterator pos;
    for(pos = contactListener->contacts.begin(); pos != contactListener->contacts.end(); ++pos) {
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
