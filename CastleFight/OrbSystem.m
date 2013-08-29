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
#import "PlayerComponent.h"
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
            NSArray *nextColumn = [board nextColumn];
            NSAssert(nextColumn.count == kOrbBoardRows, @"nextColumn.count is not enough for creating orbs.");
            
            // Too much orbs
            if (board.columns.count == maxColumns) {
                for (Entity *orb in [board.columns objectAtIndex:0]) {
                    RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
                    OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                    if (orbCom.type == OrbPurple) {
                        PlayerComponent *enemyPlayerCom = (PlayerComponent *)[board.aiPlayer getComponentOfName:[PlayerComponent name]];
                        enemyPlayerCom.mana += kManaForEachEnemyOrb;
                        CCLOG(@"add AI player mana!");
                    }
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
                
                // create orb!
                OrbType type = [[nextColumn objectAtIndex:row] intValue];
                
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
