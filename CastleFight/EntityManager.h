//
//  EntityManager.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Entity.h"

@interface EntityManager : NSObject

-(Entity *)createEntity;
-(void)removeEntity:(Entity *)entity;

-(void)addComponent:(Component *)component toEntity:(Entity *)entity;
-(void)removeComponentOfClass:(Class)class fromEntity:(Entity *)entity;

-(Component *)getComponentOfClass:(Class)class fromEntity:(Entity *)entity;
-(NSArray *)getAllComponentsOfEntity:(Entity *)entity;

-(NSArray *)getAllEntitiesPosessingComponentOfClass:(Class)class;

@end
