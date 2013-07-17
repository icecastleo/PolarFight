//
//  MyContactListener.h
//  CastleFight
//
//  Created by 朱 世光 on 13/7/13.
//
//

#ifndef __CastleFight__MyContactListener__
#define __CastleFight__MyContactListener__

#include "Box2D.h"
#import <vector>

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


#endif /* defined(__CastleFight__MyContactListener__) */
