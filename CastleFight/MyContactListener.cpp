//
//  MyContactListener.cpp
//  CastleFight
//
//  Created by 朱 世光 on 13/7/13.
//
//

#include "MyContactListener.h"

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
