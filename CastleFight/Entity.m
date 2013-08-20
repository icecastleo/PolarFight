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

-(void)removeComponent:(NSString *)name {
    [_entityManager removeComponentOfName:name fromEntity:self];
}

-(Component *)getComponentOfName:(NSString *)name {
    return [_entityManager getComponentOfName:name fromEntity:self];
}

-(NSArray *)getAllComponents {
    return [_entityManager getAllComponentsOfEntity:self];
}

-(NSArray *)getAllEntitiesPosessingComponentOfName:(NSString *)name {
    return [_entityManager getAllEntitiesPosessingComponentOfName:name];
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
