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
#import "RenderComponent.h"
#import "AliveComponent.h"

@interface Entity() {
    EntityManager *_entityManager;
    RenderComponent *render;
}

@end

@implementation Entity

@dynamic position;

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

-(BOOL)isDead {
    AliveComponent *alive = (AliveComponent *)[self getComponentOfName:[AliveComponent name]];
    
    if (alive == nil || alive.isDead) {
        return YES;
    } else {
        return NO;
    }
}

-(void)setPosition:(CGPoint)position {
    if (render == nil) {
        render = (RenderComponent *)[self getComponentOfName:[RenderComponent name]];
        NSAssert(render, @"We need render component to set position!");
    }
    
    render.node.position = position;
}

-(CGPoint)position {
    if (render == nil) {
        render = (RenderComponent *)[self getComponentOfName:[RenderComponent name]];
        NSAssert(render, @"We need render component to get position!");
    }
    
    return render.node.position;
}

-(CGRect)boundingBox {
    if (render == nil) {
        render = (RenderComponent *)[self getComponentOfName:[RenderComponent name]];
        NSAssert(render, @"We need render component to get position!");
    }
    
    return render.sprite.boundingBox;
}

@end
