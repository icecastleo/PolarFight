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

@implementation OrbSystem

-(void)update:(float)delta {
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfName:[OrbBoardComponent name]]) {
        OrbBoardComponent *board = (OrbBoardComponent *)[entity getComponentOfName:[OrbBoardComponent name]];
        
        if (board.status != kOrbBoardStatusStart) {
            continue;
        }
        
        if (board.timeCountdown > 0) {
            board.timeCountdown = MAX(0, board.timeCountdown - delta);
        }
        
        if (board.orbCountdown <= 0) {
            board.orbCountdown += kOrbWidth;
            
            if (board.timeCountdown > 0) {
                // Too much orbs
                if (board.columns.count == board.maxColumns) {
                    [self removeFirstColumnsInBoard:board];
                }
                
                NSArray *nextColumn = [board nextColumn];
                NSAssert(nextColumn.count == kOrbBoardRows, @"Columns's patter does not match orb's row.");
                
                NSMutableArray *column = [[NSMutableArray alloc] initWithCapacity:kOrbBoardRows];
                for (int row = 0; row < kOrbBoardRows; row++) {
                    // create orb!
                    Entity *orb = [self.entityFactory createOrb:[nextColumn objectAtIndex:row] withPlayer:board.player];
                    RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
                    
                    if (board.columns.count == 0) {
                        render.node.position = ccp(kOrbBoardColumns * kOrbWidth + kOrbBoradLeftMargin, kOrbHeight/2 + kOrbHeight * row + kOrbBoradDownMargin);
                    } else {
                        Entity *lastEntity = [[board.columns lastObject] objectAtIndex:row];
                        RenderComponent *lastEntityRender = (RenderComponent *)[lastEntity getComponentOfName:[RenderComponent name]];
                        render.node.position = ccp(lastEntityRender.position.x + kOrbWidth, lastEntityRender.position.y);
                    }
                    
                    OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
                    if ([orbCom respondsToSelector:@selector(touchEndLine)]) {
                        [orbCom touchEndLine];
                    }
                    [render.sprite runAction:
                     [CCSequence actions:
                      [CCFadeOut actionWithDuration:0.5f],
                      [CCCallBlock actionWithBlock:^{
                         [render.node removeFromParentAndCleanup:YES];
                     }],nil]];
                    
                    [column addObject:orb];
                }
                
                [board.columns removeObjectAtIndex:0];
            }

            NSMutableArray *column = [[NSMutableArray alloc] initWithCapacity:kOrbBoardRows];
            for (int row = 0; row < kOrbBoardRows; row++) {
                // create orb!
                Entity *orb = [self.entityFactory createOrb:[nextColumn objectAtIndex:row]];
                RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
                
                if (board.columns.count == 0) {
                    render.node.position = ccp(kOrbBoardColumns * kOrbWidth + kOrbBoradLeftMargin, kOrbHeight/2 + kOrbHeight * row + kOrbBoradDownMargin);
                } else {
                    Entity *lastEntity = [[board.columns lastObject] objectAtIndex:row];
                    RenderComponent *lastEntityRender = (RenderComponent *)[lastEntity getComponentOfName:[RenderComponent name]];
                    render.node.position = ccp(lastEntityRender.position.x + kOrbWidth, lastEntityRender.position.y);
                }
            }
        }
        
        for (NSArray *column in board.columns) {
            for (Entity *orb in column) {
                RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
                render.node.position = ccp(render.node.position.x - kOrbSpeed * delta, render.node.position.y);
            }
        }
        
        board.orbCountdown -= kOrbSpeed * delta;
    }
}

-(void)removeFirstColumnsInBoard:(OrbBoardComponent *)board {
    for (Entity *orb in [board.columns objectAtIndex:0]) {
        RenderComponent *render = (RenderComponent *)[orb getComponentOfName:[RenderComponent name]];
        
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        [orbCom touchEndLine];
        
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

@end
