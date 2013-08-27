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

//-(void)update:(float)delta {
//    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[OrbBoardComponent name]]) {
//        OrbBoardComponent *board = (OrbBoardComponent *)[entity getComponentOfName:[OrbBoardComponent name]];
//        
//        if (countDown <= 0) {
//            countDown += kOrbWidth;
//
//            for (int row = 0; row < kOrbBoardRows; row++) {
//                
//                // Random to create orb!
//                OrbType type = arc4random_uniform(OrbBottom - 1) + 1;
//                
//                if (arc4random_uniform(2) == 0) {
//                    type = OrbNull;
//                }
//                
//                Entity *orb = [self.entityFactory createOrb:type row:row];
//                RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
//                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
//                orbCom.board = board;
//                [board adjustOrbPosition:orb realPosition:orbRenderCom.node.position];
//                [board.orbs addObject:orb];
//                
//            }
//            
//            // Too much orbs
////            if (board.columns.count > maxColumns) {
////                for (Entity *orb in [board.columns objectAtIndex:0]) {
////                    RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
////                    
////                    [render.sprite runAction:
////                     [CCSequence actions:
////                      [CCFadeOut actionWithDuration:0.5f],
////                      [CCCallBlock actionWithBlock:^{
////                         [render.node removeFromParentAndCleanup:YES];
////                     }],nil]];
////
////                    [orb removeSelf];
////                }
////                
////            }
//        }
//        
//        for (Entity *orb in board.orbs) {
//            RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
//            orbRenderCom.node.position = ccp(orbRenderCom.node.position.x - kOrbSpeed * delta, orbRenderCom.node.position.y);
//            [board adjustOrbPosition:orb realPosition:orbRenderCom.node.position];
//        }
//        
//        [board clean];
//        
//        countDown -= kOrbSpeed * delta;
//    }
//}

-(void)update:(float)delta {
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[OrbBoardComponent name]]) {
        OrbBoardComponent *board = (OrbBoardComponent *)[entity getComponentOfName:[OrbBoardComponent name]];
        
        if (countDown <= 0) {
            countDown += kOrbWidth;
            
            // Too much orbs
            if (board.columns.count == maxColumns) {
                for (Entity *orb in [board.columns objectAtIndex:0]) {
                    RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
                    
                    [render.sprite runAction:
                     [CCSequence actions:
                      [CCFadeOut actionWithDuration:0.5f],
                      [CCCallBlock actionWithBlock:^{
                         [render.node removeFromParentAndCleanup:YES];
                     }],nil]];
                    
                    [orb removeSelf];
                }
                
                [board.columns removeObjectAtIndex:0];
            }

            NSMutableArray *column = [[NSMutableArray alloc] initWithCapacity:kOrbBoardRows];
            for (int row = 0; row < kOrbBoardRows; row++) {
                
                OrbType type;
                
                // Random to create orb!
                if (arc4random_uniform(3) > 0) {
                    type = OrbNull;
                } else {
                    type = arc4random_uniform(OrbBottom - 1) + 1;
                }
                
                Entity *orb = [self.entityFactory createOrb:type row:row];
            
                OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                orbCom.board = board;
                
                [column addObject:orb];
            }
            [board.columns addObject:column];
        }
        
        for (NSArray *column in board.columns) {
            for (Entity *orb in column) {
                RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
                render.node.position = ccp(render.node.position.x - kOrbSpeed * delta, render.node.position.y);
            }
        }
        
        countDown -= kOrbSpeed * delta;
    }
}

@end
