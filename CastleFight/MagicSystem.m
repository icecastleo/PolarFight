//
//  MagicSystem.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/25.
//
//

#import "MagicSystem.h"
#import "MapLayer.h"
#import "MagicComponent.h"
#import "Magic.h"

@implementation MagicSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory mapLayer:(MapLayer *)map {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        _map = map;
    }
    return self;
}

-(void)update:(float)delta {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[MagicComponent class]];
    
    for (Entity *entity in entities) {
        MagicComponent *magicCom = (MagicComponent *)[entity getComponentOfClass:[MagicComponent class]];
        for (Magic *magic in magicCom.magicQueue) {
            magic.map = self.map;
            [magic active];
        }
        [magicCom.magicQueue removeAllObjects];
    }
}

@end
