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
        [component receiveEvent:type Message:message];
    }
}

//- (Entity *)closestEntityOnTeam:(int)team {
//
//    RenderComponent * ourRender = self.render;
//    if (!ourRender) return nil;
//    
//    Entity * closestEntity = nil;
//    float closestEntityDistance = -1;
//    
//    NSArray * allEntities = [self getAllEntitiesOnTeam:team posessingComponentOfClass:[RenderComponent class]];
//    for (Entity * entity in allEntities) {
//        RenderComponent * otherRender = entity.render;
//        float distance = ccpDistance(ourRender.node.position, otherRender.node.position);
//        if (distance < closestEntityDistance || closestEntityDistance == -1) {
//            closestEntity = entity;
//            closestEntityDistance = distance;
//        }
//    }
//    
//    return closestEntity;
//}
//
//- (Entity *)playerForTeam:(int)team {
//    NSArray * players = [self getAllEntitiesOnTeam:team posessingComponentOfClass:[PlayerComponent class]];
//    return players[0];
//}
//
//- (NSArray *)entitiesWithinRange:(float)range onTeam:(int)team {
//    
//    RenderComponent * ourRender = self.render;
//    if (!ourRender) return nil;
//    
//    NSArray * allEntities = [self getAllEntitiesOnTeam:team posessingComponentOfClass:[RenderComponent class]];
//    NSMutableArray * retval = [NSMutableArray arrayWithCapacity:allEntities.count];
//    for (Entity * entity in allEntities) {
//        RenderComponent * otherRender = entity.render;
//        float distance = ccpDistance(ourRender.node.position, otherRender.node.position);
//        if (distance < range) {
//            [retval addObject:entity];
//        }
//    }
//    
//    return retval;
//}

@end
