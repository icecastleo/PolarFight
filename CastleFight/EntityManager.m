//
//  EntityManager.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "EntityManager.h"
#import "Component.h"

@interface EntityManager() {
    NSMutableArray *_entities;
    NSMutableDictionary *_componentsByClass;
    NSMutableDictionary *_componentsByEntity;
    uint32_t _lowestUnassignedEid;
}
-(uint32_t)generateNewEid;

@end

@implementation EntityManager

-(id)init {
    if ((self = [super init])) {        
        _entities = [NSMutableArray array];
        _componentsByClass = [NSMutableDictionary dictionary];
        _componentsByEntity = [NSMutableDictionary dictionary];
        _lowestUnassignedEid = 1;
    }
    return self;
}

-(uint32_t)generateNewEid {
    if (_lowestUnassignedEid < UINT32_MAX) {
        return _lowestUnassignedEid++;
    } else {
        for (uint32_t i = 1; i < UINT32_MAX; ++i) {
            if (![_entities containsObject:@(i)]) {
                return i;
            }
        }
        CCLOG(@"[%@] ERROR: no available Entity IDs; too many entities! (more than %i)", [self class], INT32_MAX );
        return 0;
    }
}

-(Entity *)createEntity {
    uint32_t eid = [self generateNewEid];
    [_entities addObject:@(eid)];
    
    NSMutableDictionary *components = [NSMutableDictionary dictionary];
    _componentsByEntity[@(eid)] = components;
    
    return [[Entity alloc] initWithEid:eid entityManager:self];
}

-(void)removeEntity:(Entity *)entity {
    for (NSMutableDictionary *components in _componentsByClass.allValues) {
        if (components[entity.eidNumber]) {
            Component *component = components[entity.eidNumber];
            if ([component respondsToSelector:@selector(receiveEvent:Message:)]) {
                [component receiveEvent:kEntityEventRemoveComponent Message:component];
            }
            
            [components removeObjectForKey:entity.eidNumber];
        }
    }
    
    [_componentsByEntity removeObjectForKey:entity.eidNumber];
    [_entities removeObject:entity.eidNumber];
}

-(void)addComponent:(Component *)component toEntity:(Entity *)entity {
    NSMutableDictionary *components = _componentsByClass[[[component class] name]];
    
    if (!components) {
        components = [NSMutableDictionary dictionary];
        _componentsByClass[NSStringFromClass([component class])] = components;
    }
    
    components[entity.eidNumber] = component;
    [_componentsByEntity[entity.eidNumber] setObject:component forKey:NSStringFromClass([component class])];
}

//-(void)removeComponentOfName:(Class)aClass fromEntity:(Entity *)entity {
//    NSMutableDictionary * components = _componentsByClass[NSStringFromClass(aClass)];
//    if (components && components[entity.eidNumber]) {
//        Component *component = components[entity.eidNumber];
//        if ([component respondsToSelector:@selector(receiveEvent:Message:)]) {
//            [component receiveEvent:kEntityEventRemoveComponent Message:component];
//        }
//
//        [components removeObjectForKey:entity.eidNumber];
//        [_componentsByEntity[entity.eidNumber] removeObjectForKey:NSStringFromClass(aClass)];
//    }
//}

-(void)removeComponentOfName:(NSString *)name fromEntity:(Entity *)entity {
    NSMutableDictionary *components = _componentsByClass[name];
    
    if (components && components[entity.eidNumber]) {
        Component *component = components[entity.eidNumber];
        
        if ([component respondsToSelector:@selector(receiveEvent:Message:)]) {
            [component receiveEvent:kEntityEventRemoveComponent Message:component];
        }
        
        [components removeObjectForKey:entity.eidNumber];
        [_componentsByEntity[entity.eidNumber] removeObjectForKey:name];
    }
}

//-(Component *)getComponentOfName:(Class)aClass fromEntity:(Entity *)entity {
//    return _componentsByClass[NSStringFromClass(aClass)][entity.eidNumber];
//}

-(Component *)getComponentOfName:(NSString *)name fromEntity:(Entity *)entity {
    return _componentsByClass[name][entity.eidNumber];
}

-(NSArray *)getAllComponentsOfEntity:(Entity *)entity {
    return [_componentsByEntity[entity.eidNumber] allValues];
}

//-(NSArray *)getAllEntitiesPosessingComponentOfName:(Class)aClass {
//    NSMutableDictionary * components = _componentsByClass[NSStringFromClass(aClass)];
//    if (components) {
//        NSMutableArray * retval = [NSMutableArray arrayWithCapacity:components.allKeys.count];
//        for (NSNumber * eid in components.allKeys) {
//            [retval addObject:[[Entity alloc] initWithEid:eid.integerValue entityManager:self]];
//        }
//        return retval;
//    } else {
//        return [NSArray array];
//    }
//}

-(NSArray *)getAllEntitiesPosessingComponentOfName:(NSString *)name {
    NSMutableDictionary *components = _componentsByClass[name];
    
    if (components) {
        NSMutableArray *retval = [NSMutableArray arrayWithCapacity:components.allKeys.count];
        for (NSNumber *eid in components.allKeys) {
            [retval addObject:[[Entity alloc] initWithEid:eid.integerValue entityManager:self]];
        }
        return retval;
    } else {
        return [NSArray array];
    }
}

@end
