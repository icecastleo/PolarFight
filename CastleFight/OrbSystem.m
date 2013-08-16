//
//  OrbSystem.m
//  CastleFight
//
//  Created by  DAN on 13/8/15.
//
//

#import "OrbSystem.h"
#import "OrbBoardComponent.h"
#import "OrbComponent.h"
#import "RenderComponent.h"

@implementation OrbSystem

-(void)update:(float)delta {
    
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfClass:[OrbBoardComponent class]]) {
        OrbBoardComponent *orbBoardCom = (OrbBoardComponent *)[entity getComponentOfClass:[OrbBoardComponent class]];
//        [orbBoardCom moveBoard];
        if (orbBoardCom.currentColumn < 0) {
            [orbBoardCom produceOrbs];
            return;
        }
        for (NSArray *column in orbBoardCom.board) {
            for (Entity *orb in column) {
                RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfClass:[RenderComponent class]];
                orbRenderCom.node.position = ccp(orbRenderCom.node.position.x-3,orbRenderCom.node.position.y);
            }
        }
        RenderComponent *boardRenderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
        CGPoint position = [boardRenderCom.sprite convertToNodeSpace:ccp(boardRenderCom.sprite.boundingBox.size.width,0)];
        position = [boardRenderCom.node convertToWorldSpace:position];
        
        NSArray *lastColumn = [orbBoardCom.board lastObject];
        Entity *lastOrb = [lastColumn lastObject];
        RenderComponent *orbRenderCom = (RenderComponent *)[lastOrb getComponentOfClass:[RenderComponent class]];
        if (orbRenderCom.node.position.x < position.x) {
            [orbBoardCom produceOrbs];
        }
        
        NSArray *startColumn = [orbBoardCom.board objectAtIndex:0];
        Entity *startOrb = [startColumn lastObject];
        RenderComponent *startOrbRenderCom = (RenderComponent *)[startOrb getComponentOfClass:[RenderComponent class]];
        
        if (!startOrbRenderCom) {
            return;
        }
        
        CGPoint startOrbPosition = [boardRenderCom.node convertToWorldSpace:startOrbRenderCom.node.position];
        
        if(startOrbPosition.x < boardRenderCom.node.position.x) {
            for (Entity *orb in startColumn) {
                RenderComponent *orbRenderCom = (RenderComponent *)[orb getComponentOfClass:[RenderComponent class]];
                [orbRenderCom.node removeFromParentAndCleanup:YES];
                [self.entityManager removeEntity:orb];
            }
            [orbBoardCom removeColumn:[orbBoardCom.board indexOfObject:startColumn]];
        }
    }
}

@end
