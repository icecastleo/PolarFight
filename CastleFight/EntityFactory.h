//
//  EntityFactory.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "EntityManager.h"
#import "MapLayer.h"
@class PhysicsSystem;

@interface EntityFactory : NSObject

@property MapLayer *mapLayer;
@property PhysicsSystem *physicsSystem;

-(id)initWithEntityManager:(EntityManager *)entityManager;

-(Entity *)createCharacter:(NSString *)cid level:(int)level forTeam:(int)team;
-(Entity *)createCharacter:(NSString *)cid level:(int)level forTeam:(int)team  isSummon:(bool)summon;
-(Entity *)createCastleForTeam:(int)team;
-(Entity *)createPlayerForTeam:(int)team;

-(Entity *)createMagicButton:(NSString *)cid level:(int)level;

@end
