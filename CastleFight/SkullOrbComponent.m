//
//  SkullOrbComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/9/12.
//
//

#import "SkullOrbComponent.h"
#import "RenderComponent.h"
#import "PlayerComponent.h"
#import "OrbBoardComponent.h"

@implementation SkullOrbComponent

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    
    RenderComponent *render = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    
    CCSprite *skull = [CCSprite spriteWithFile:@"skull.png"];
    skull.position = ccpSub(ccp(render.sprite.contentSize.width/2, render.sprite.contentSize.height/2), skull.offsetPosition);
    
    if (skull.boundingBox.size.width > skull.boundingBox.size.height) {
        skull.scale = kOrbWidth/skull.boundingBox.size.width/render.sprite.scale*0.75;
    } else {
        skull.scale = kOrbHeight/skull.boundingBox.size.height/render.sprite.scale*0.75;
    }
    [render.sprite addChild:skull];
}

-(void)touchEndLine {
    
    if (self.color == OrbNull) {
        return;
    }
    
    int skullCount = 1;
    int manaBonus = 0;
    
    RenderComponent *currentRenderCom = (RenderComponent *)[self.entity getComponentOfName:[RenderComponent name]];
    CGPoint currentOrbPosition = [self.board convertRenderPositionToOrbPosition:currentRenderCom.node.position];
    int currentX = currentOrbPosition.x;
    int currentY = currentOrbPosition.y;
    int currentColumns = self.board.columns.count;
    
    NSMutableArray *matchArray = [[NSMutableArray alloc] init];
    
    [matchArray addObject:self.entity];
    
    for (int i=currentX+1; i<currentColumns; i++) {
        CGPoint orbPosition = ccp(i,currentY);
        Entity *orb = [self.board orbAtPosition:orbPosition];
        OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
        if ([orbCom.type isEqualToString:self.type]) {
            [matchArray addObject:orb];
            skullCount++;
        }else if(orbCom.color != OrbNull) {
            [matchArray addObject:orb];
            manaBonus++;
        }
    }
    
    [self bombOrb:matchArray];
    
    PlayerComponent *enemyPlayerCom = (PlayerComponent *)[self.board.aiPlayer getComponentOfName:[PlayerComponent name]];
    enemyPlayerCom.mana += skullCount * (kManaForEachEnemyOrb+manaBonus);
    
    CCLOG(@"add AI player mana!");
}

-(void)bombOrb:(NSMutableArray *)bombArray {
    NSMutableArray *removeArray = [[NSMutableArray alloc] init];
    
    Entity *orb = [bombArray objectAtIndex:0];
    OrbComponent *orbCom = (OrbComponent *)[orb getComponentOfName:[OrbComponent name]];
    [orbCom disappearAfterMatch];
    [removeArray addObject:orb];
    
    [bombArray removeObjectsInArray:removeArray];
    
    if (bombArray.count > 0) {
        [self performSelector:@selector(bombOrb:) withObject:bombArray afterDelay:kOrbBombDelay];
    }
}

@end
