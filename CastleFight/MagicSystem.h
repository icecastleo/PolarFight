//
//  MagicSystem.h
//  CastleFight
//
//  Created by  浩翔 on 13/6/25.
//
//

#import "System.h"

@class MapLayer;

@interface MagicSystem : System

@property (readonly) MapLayer *map;

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory mapLayer:(MapLayer *)map;

@end