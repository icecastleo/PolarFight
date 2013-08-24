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

@implementation OrbSystem

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

@end
