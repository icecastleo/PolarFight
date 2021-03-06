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
@class BattleDataObject;

@interface EntityFactory : NSObject

@property MapLayer *mapLayer;
@property PhysicsSystem *physicsSystem;

-(id)initWithEntityManager:(EntityManager *)entityManager;

-(Entity *)createCharacter:(NSString *)cid level:(int)level forTeam:(int)team;
-(Entity *)createCharacter:(NSString *)cid level:(int)level forTeam:(int)team scale:(float)scale;

-(NSArray *)createGroupCharacter:(NSString *)cid withCount:(int)count forTeam:(int)team BonusCount:(int)bonusCount;

-(Entity *)createCastleForTeam:(int)team;

-(Entity *)createUserPlayerForTeam:(int)team;
-(Entity *)createEnemyPlayerForTeam:(int)team battleData:(BattleDataObject *)battleData;

-(Entity *)createMagicButton:(NSString *)cid level:(int)level team:(int)team;
-(Entity *)createOrb:(NSString *)orbId;
-(Entity *)createOrbBoardWithUser:(Entity *)player AIPlayer:(Entity *)aiPlayer andBattleData:(BattleDataObject *)battleData;

-(Entity *)createProjectileEntityWithEvent:(ProjectileEvent *)event forTeam:(int)team;

-(Entity *)createItemButton:(NSString *)cid count:(int)count;

@end
