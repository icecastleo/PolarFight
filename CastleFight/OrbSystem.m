//
//  OrbSystem.m
//  CastleFight
//
//  Created by  浩翔 on 13/8/15.
//
//

#import "OrbSystem.h"
#import "OrbBoardComponent.h"
#import "OrbComponent.h"
#import "RenderComponent.h"

@interface OrbSystem () {
    int maxColumns;
    
    float countDown;
}

@end

@implementation OrbSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        maxColumns = kOrbBoardColumns;
        countDown = 0;
    }
    return self;
}

-(void)update:(float)delta {
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[OrbBoardComponent name]]) {
        OrbBoardComponent *board = (OrbBoardComponent *)[entity getComponentOfName:[OrbBoardComponent name]];
        
        if (countDown <= 0) {
            countDown += kOrbWidth;

            for (int row = 0; row < kOrbBoardRows; row++) {
                
                // Random to create orb!
                OrbType type = arc4random_uniform(OrbBottom - 1) + 1;
                
                if (arc4random_uniform(2) == 0) {
                    type = OrbNull;
                }
                
                Entity *orb = [self.entityFactory createOrb:type row:row];
                RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                orbCom.board = board;
                [board adjustOrbPosition:orb realPosition:orbRenderCom.node.position];
                [board.orbs addObject:orb];
                
            }
            
            // Too much orbs
//            if (board.columns.count > maxColumns) {
//                for (Entity *orb in [board.columns objectAtIndex:0]) {
//                    RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
//                    
//                    [render.sprite runAction:
//                     [CCSequence actions:
//                      [CCFadeOut actionWithDuration:0.5f],
//                      [CCCallBlock actionWithBlock:^{
//                         [render.node removeFromParentAndCleanup:YES];
//                     }],nil]];
//
//                    [orb removeSelf];
//                }
//                
//            }
        }
        
        for (Entity *orb in board.orbs) {
            RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
            orbRenderCom.node.position = ccp(orbRenderCom.node.position.x - kOrbSpeed * delta, orbRenderCom.node.position.y);
            [board adjustOrbPosition:orb realPosition:orbRenderCom.node.position];
        }
        
        [board clean];
        
        countDown -= kOrbSpeed * delta;
    }
}

/*
-(void)update:(float)delta {
    
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[OrbBoardComponent name]]) {
        OrbBoardComponent *orbBoardCom = (OrbBoardComponent *)[entity getComponentOfName:[OrbBoardComponent name]];
        
        if (orbBoardCom.board.count == 0) {
            [orbBoardCom produceOrbs];
            return;
        }
        int lastOrbX = 0;
        for(Entity *orb in orbBoardCom.board) {
            RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
            orbRenderCom.node.position = ccp(orbRenderCom.node.position.x-1,orbRenderCom.node.position.y);
            if (orbRenderCom.node.position.x > lastOrbX) {
                lastOrbX = orbRenderCom.node.position.x;
            }
            [orbBoardCom adjustOrbPosition:orb realPosition:orbRenderCom.node.position];
        }
        
        [orbBoardCom clean];
        
        RenderComponent *boardRenderCom = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        CGPoint position = [boardRenderCom.sprite convertToNodeSpace:ccp(boardRenderCom.sprite.boundingBox.size.width,0)];
        position = [boardRenderCom.node convertToWorldSpace:position];
        
        if (lastOrbX < position.x) {
            [orbBoardCom produceOrbs];
        }
        
    }
}
//*/
@end
