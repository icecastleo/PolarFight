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
  
    CCParallaxNode *node = [CCParallaxNode node];
    int repeat = 3;
    
    CCSprite *preloadMap = [CCSprite spriteWithFile:@"ice.png"];
    int width = preloadMap.boundingBox.size.width;
    int height = preloadMap.boundingBox.size.height;
    
    for(int i = 0; i < repeat; i++) {
        CCSprite *map = [CCSprite spriteWithFile:@"ice.png"];
        map.anchorPoint = ccp(0, 0);
        [node addChild:map z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(width*i-i, 0)];
    }

    [self addChild:node];
    self.contentSize = CGSizeMake(width*repeat, height);
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
