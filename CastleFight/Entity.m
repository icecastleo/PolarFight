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

@implementation Entity {
    EntityManager * _entityManager;
}

- (id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager {
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

-(void)removeComponent:(Class)class {
    [_entityManager removeComponentOfClass:class fromEntity:self];
}

-(Component *)getComponentOfClass:(Class)class {
    return [_entityManager getComponentOfClass:class fromEntity:self];
}

-(NSArray *)getAllComponents {
    return [_entityManager getAllComponentsOfEntity:self];
}

-(NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)class {
    return [_entityManager getAllEntitiesPosessingComponentOfClass:class];
}

-(void)sendEvent:(EventType)type Message:(id)message {
    NSArray *components = [self getAllComponents];
    
    for (Component *component in components) {
        if ([component respondsToSelector:@selector(receiveEvent:Message:)]) {
            [component receiveEvent:type Message:message];
        }
    }
}

@end
