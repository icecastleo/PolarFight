//
//  Entity.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

@class Component;
@class EntityManager;

//typedef enum {
//    kEntityStateIdel,
//    kEntityStateMove,
//    kEntityStateAttack,
//    kEntityStateDead,
//} EntityState;

typedef enum {
    kEventTypeLevelChanged,
    
    kEventSendAttackEvent,
    kEventReceiveAttackEvent,
    kEventSendDamageEvent,
    kEventReceiveDamageEvent,
    kEventReceiveDamage,
    
    KEventDead,
    
    kEventFoodChanged,
    
} EventType;

@interface Entity : NSObject {
    
}

@property (readonly) uint32_t eid;
//@property EntityState state;

-(id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager;

-(void)addComponent:(Component*)component;
-(void)removeComponent:(Class)class;

-(Component*)getComponentOfClass:(Class)class;
-(NSArray *)getAllComponents;

-(NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)class;

-(void)sendEvent:(EventType)type Message:(id)message;

//- (NSArray *)getAllEntitiesOnTeam:(int)team posessingComponentOfClass:(Class)class;
//- (Entity *)closestEntityOnTeam:(int)team;
//- (Entity *)playerForTeam:(int)team;
//- (NSArray *)entitiesWithinRange:(float)range onTeam:(int)team;

@end
