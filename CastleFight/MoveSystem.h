//
//  MoveSystem.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "System.h"
#import "MapLayer.h"

@interface MoveSystem : System

@property (readonly) MapLayer *map;

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory mapLayer:(MapLayer *)map;

@end
