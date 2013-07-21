//
//  Entity.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"
#import "Entity.h"
#import "EntityManager.h"

@interface Entity() {
    EntityManager *_entityManager;
}

@end

@implementation Entity

-(id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager {
    if ((self = [super init])) {
        _eid = eid;
        _eidNumber = @(eid);
        _entityManager = entityManager;
    }
    return self;
}

-(void)addComponent:(Component *)component {
    [_entityManager addComponent:component toEntity:self];
    component.entity = self;
}

-(void)removeComponent:(Class)aClass {
    [_entityManager removeComponentOfClass:aClass fromEntity:self];
}

-(Component *)getComponentOfClass:(Class)aClass {
    return [_entityManager getComponentOfClass:aClass fromEntity:self];
}

-(NSArray *)getAllComponents {
    return [_entityManager getAllComponentsOfEntity:self];
}

-(NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)aClass {
    return [_entityManager getAllEntitiesPosessingComponentOfClass:aClass];
}

-(void)removeSelf {
    [_entityManager removeEntity:self];
}

-(void)sendEvent:(EntityEvent)type Message:(id)message {
    NSArray *components = [self getAllComponents];
    
    for (Component *component in components) {
        if ([component respondsToSelector:@selector(receiveEvent:Message:)]) {
            [component receiveEvent:type Message:message];
        }
    }
}

@end
