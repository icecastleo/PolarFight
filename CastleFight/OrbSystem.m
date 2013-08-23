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
    }
    return self;
}

-(void)update:(float)delta {
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[OrbBoardComponent name]]) {
        OrbBoardComponent *board = (OrbBoardComponent *)[entity getComponentOfName:[OrbBoardComponent name]];
        
        if (countDown <= 0) {
            countDown += kOrbWidth;

            NSMutableArray *column = [[NSMutableArray alloc] init];
            for (int row = 0; row < kOrbBoardRows; row++) {
                
                // Random to create orb!
                if (arc4random_uniform(2) == 0) {
                    continue;
                }
                
                OrbType type = arc4random_uniform(OrbBottom - 1) + 1;
                Entity *orb = [self.entityFactory createOrb:type row:row];
                [column addObject:orb];
            }
            [board.columns addObject:column];
            
            // Too much orbs
            if (board.columns.count > maxColumns) {
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
        }
        
        for (NSArray *column in board.columns) {
            for (Entity *orb in column) {
                RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
                render.node.position = ccp(render.node.position.x - kOrbSpeed * delta, render.node.position.y);
            }
        }
        
        countDown -= kOrbSpeed * delta;
    }
    
    
    
//    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[OrbBoardComponent name]]) {
//        OrbBoardComponent *orbBoardCom = (OrbBoardComponent *)[entity getComponentOfName:[OrbBoardComponent name]];
////        [orbBoardCom moveBoard];
//        if (orbBoardCom.currentColumn < 0) {
//            [orbBoardCom produceOrbs];
//            return;
//        }
//        for (NSArray *column in orbBoardCom.board) {
//            for (Entity *orb in column) {
//                RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
//                orbRenderCom.node.position = ccp(orbRenderCom.node.position.x-3,orbRenderCom.node.position.y);
//            }
//        }
//        RenderComponent *boardRenderCom = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
//        CGPoint position = [boardRenderCom.sprite convertToNodeSpace:ccp(boardRenderCom.sprite.boundingBox.size.width,0)];
//        position = [boardRenderCom.node convertToWorldSpace:position];
//        
//        NSArray *lastColumn = [orbBoardCom.board lastObject];
//        Entity *lastOrb = [lastColumn lastObject];
//        RenderComponent *orbRenderCom = (RenderComponent *)[lastOrb getComponentOfName:[RenderComponent name]];
//        if (orbRenderCom.node.position.x < position.x) {
//            [orbBoardCom produceOrbs];
//        }
//        
//        NSArray *startColumn = [orbBoardCom.board objectAtIndex:0];
//        Entity *startOrb = [startColumn lastObject];
//        RenderComponent *startOrbRenderCom = (RenderComponent *)[startOrb getComponentOfName:[RenderComponent name]];
//        
//        if (!startOrbRenderCom) {
//            return;
//        }
//        
//        CGPoint startOrbPosition = [boardRenderCom.node convertToWorldSpace:startOrbRenderCom.node.position];
//        
//        if(startOrbPosition.x < boardRenderCom.node.position.x) {
//            for (Entity *orb in startColumn) {
//                RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
//                [orbRenderCom.node removeFromParentAndCleanup:YES];
//                [self.entityManager removeEntity:orb];
//            }
//            [orbBoardCom removeColumn:[orbBoardCom.board indexOfObject:startColumn]];
//        }
//    }
}

@end
