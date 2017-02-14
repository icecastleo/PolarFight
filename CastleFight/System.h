//
//  System.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "EntityManager.h"
#import "EntityFactory.h"

@interface System : NSObject

@property EntityManager *entityManager;
@property EntityFactory *entityFactory;

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory;
-(void)update:(float)delta;

@end