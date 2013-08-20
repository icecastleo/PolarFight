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
//-(void)removeComponentOfName:(Class)aClass fromEntity:(Entity *)entity;
-(void)removeComponentOfName:(NSString *)name fromEntity:(Entity *)entity;

//-(Component *)getComponentOfName:(Class)aClass fromEntity:(Entity *)entity;
-(Component *)getComponentOfName:(NSString *)name fromEntity:(Entity *)entity;
-(NSArray *)getAllComponentsOfEntity:(Entity *)entity;

//-(NSArray *)getAllEntitiesPosessingComponentOfName:(Class)aClass;
-(NSArray *)getAllEntitiesPosessingComponentOfName:(NSString *)name;

@end
