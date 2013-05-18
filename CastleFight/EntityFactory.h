//
//  EntityFactory.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "EntityManager.h"
#import "MapLayer.h"

@interface EntityFactory : NSObject {
    
}

@property MapLayer *mapLayer;

-(id)initWithEntityManager:(EntityManager *)entityManager;

-(Entity *)createCharacter:(NSString *)cid level:(int)level forTeam:(int)team;
-(Entity *)createCastleForTeam:(int)team;
-(Entity *)createPlayerForTeam:(int)team;

@end