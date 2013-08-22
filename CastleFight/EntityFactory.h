//
//  EntityFactory.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "EntityManager.h"
#import "MapLayer.h"

@class ProjectileEvent;
@class PhysicsSystem;

@interface EntityFactory : NSObject

@property MapLayer *mapLayer;
@property PhysicsSystem *physicsSystem;

-(id)initWithEntityManager:(EntityManager *)entityManager;

-(Entity *)createCharacter:(NSString *)cid level:(int)level forTeam:(int)team addToMap:(BOOL)add;
-(Entity *)createCastleForTeam:(int)team;
-(Entity *)createPlayerForTeam:(int)team;

-(Entity *)createMagicButton:(NSString *)cid level:(int)level team:(int)team;
-(Entity *)createOrbForType:(OrbType)type;
-(Entity *)createOrbBoardWithOwner:(Entity *)owner;

-(Entity *)createProjectileEntityWithEvent:(ProjectileEvent *)event forTeam:(int)team;

@end
