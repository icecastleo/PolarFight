//
//  Entity.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

@class Component;
@class EntityManager;

#pragma mark - EntityEvent

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
    kEntityEventPrepare,
    kEntityEventReady,
    kEntityEventDead,
    kEntityEventRevive,

    kEventFoodChanged,
    kEventManaChanged,
    
    kEventSendMagicEvent,
    kEventUseMask,
    kEventCancelMask,
    
    kEventSelectable,
    
} EntityEvent;


#pragma mark - EntityEventDelegate

@protocol EntityEventDelegate <NSObject>

@optional
-(void)receiveEvent:(EntityEvent)type Message:(id)message;

@end

#pragma mark - Entity

@interface Entity : NSObject
    
@property (readonly) uint32_t eid;
@property (readonly) NSNumber *eidNumber;

@property (readonly) BOOL isDead;

@property CGPoint position;
@property (readonly) CGRect boundingBox;

-(id)initWithEid:(uint32_t)eid entityManager:(EntityManager *)entityManager;

-(void)addComponent:(Component*)component;
-(void)removeComponent:(NSString *)name;

-(Component*)getComponentOfName:(NSString *)name;
//-(NSArray *)getAllComponents;

-(NSArray *)getAllEntitiesPosessingComponentOfName:(NSString *)name;

-(void)removeSelf;

-(void)sendEvent:(EntityEvent)type Message:(id)message;

@end
