//
//  Entity.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

@class Component;
@class EntityManager;

typedef enum {
    // Only the removed component will receive!
    kEntityEventRemoveComponent,
    
    kEntityEventLevelChanged,
    kEntityEventDirectionChanged,
    
    kEventSendAttackEvent,
    kEventReceiveAttackEvent,
    kEventSendDamageEvent,
    kEventReceiveDamageEvent,
    kEventReceiveDamage,
    
    kEventIsActiveSkillForbidden,
    kEventIsMoveForbidden,
    kEventIsDetectedForbidden,
    kEntityEventDead,
    kEntityEventRevive,
    
    kEventFoodChanged,
    
    kEventSendMagicEvent,
    kEventUseMask,
    kEventCancelMask,
    
} EntityEvent;

@interface Entity : NSObject {
    
}

@property (readonly) uint32_t eid;
@property (readonly) NSNumber *eidNumber;

-(id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager;

-(void)addComponent:(Component*)component;
-(void)removeComponent:(Class)aClass;

-(Component*)getComponentOfClass:(Class)aClass;
-(NSArray *)getAllComponents;

-(NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)aClass;

-(void)sendEvent:(EntityEvent)type Message:(id)message;

//- (NSArray *)getAllEntitiesOnTeam:(int)team posessingComponentOfClass:(Class)class;
//- (Entity *)closestEntityOnTeam:(int)team;
//- (Entity *)playerForTeam:(int)team;
//- (NSArray *)entitiesWithinRange:(float)range onTeam:(int)team;

@end
