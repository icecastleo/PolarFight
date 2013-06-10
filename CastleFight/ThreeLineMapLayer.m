//
//  ThreeLineMapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "ThreeLineMapLayer.h"
#import "RenderComponent.h"
#import "TeamComponent.h"  
#import "CharacterComponent.h"
@implementation ThreeLineMapLayer

const static int castleDistance = 200;
const static int pathSizeHeight = 25;
const static int pathHeight = 70;

-(void)setMap:(NSString *)name {
    CCSprite *map1 = [CCSprite spriteWithFile:@"map/ice.png"];
    map1.anchorPoint = ccp(0, 0);
    CCSprite *map1_1 = [CCSprite spriteWithFile:@"background.png"];
    map1_1.anchorPoint = ccp(0, 0);
    
    CCParallaxNode *node = [CCParallaxNode node];
    
    [node addChild:map1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(0,0)];
    [node addChild:map1_1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(map1.boundingBox.size.width-1, 0)];
    
    [self addChild:node];
    
    self.contentSize = CGSizeMake(map1.boundingBox.size.width*2, map1.boundingBox.size.height);
}
-(void)addEntity:(Entity *)entity {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    if (!render) {
        return;
    }
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    
    CGPoint position;
    
    int line = arc4random_uniform(3);
    
    if (character) {
        if (team.team == 1) {
            position = ccp(castleDistance, line*80+arc4random_uniform(15) + 51);
        } else {
            position = ccp(self.boundaryX - castleDistance,line*80 +arc4random_uniform(15)+ 51);
        }
    } else {
        // castle
        if (team.team == 1) {
            position = ccp(castleDistance, pathHeight + pathSizeHeight/2);
            render.sprite.anchorPoint = ccp(1, 0.5);
        } else {
            position = ccp(self.boundaryX - castleDistance, pathHeight + pathSizeHeight / 2);
            render.sprite.anchorPoint = ccp(0, 0.5);
        }
    }
    [self addEntityWithPosition:entity toPosition:position];
    
}
@end
