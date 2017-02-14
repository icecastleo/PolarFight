//
//  BattleCatMapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "BattleCatMapLayer.h"
#import "RenderComponent.h"
#import "TeamComponent.h"
#import "CharacterComponent.h"

@implementation BattleCatMapLayer

-(void)setMap:(NSString *)name {
    // Background
    CCSprite *map1 = [CCSprite spriteWithFile:[name stringByAppendingString:@"_01.png"]];
    map1.anchorPoint = ccp(0, 0);
    CCSprite *map1_1 = [CCSprite spriteWithFile:[name stringByAppendingString:@"_01.png"]];
    map1_1.anchorPoint = ccp(0, 0);
    CCSprite *map2 = [CCSprite spriteWithFile:[name stringByAppendingString:@"_02.png"]];
    map2.anchorPoint = ccp(0, 0);
    CCSprite *map2_1 = [CCSprite spriteWithFile:[name stringByAppendingString:@"_02.png"]];
    map2_1.anchorPoint = ccp(0, 0);
    CCSprite *map3 = [CCSprite spriteWithFile:[name stringByAppendingString:@"_03.png"]];
    map3.anchorPoint = ccp(0, 0);
    CCSprite *map3_1 = [CCSprite spriteWithFile:[name stringByAppendingString:@"_03.png"]];
    map3_1.anchorPoint = ccp(0, 0);
    
    CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(50, 50, 50, 255)];
    // To fullfill the screen
    background.contentSize = CGSizeMake(map3.contentSize.width * 2, map3.contentSize.height + 21);
    [map3 addChild:background z:-5];
    
    // Create a void Node, parent Node
    CCParallaxNode *node = [CCParallaxNode node];
    
    // We add our children "layers"(sprite) to void node
    [node addChild:map1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(0,0)];
    [node addChild:map1_1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(map1.contentSize.width-1, 0)];
    [node addChild:map2 z:-2 parallaxRatio:ccp(0.75f, 1.f) positionOffset:ccp(0,90)];
    [node addChild:map2_1 z:-2 parallaxRatio:ccp(0.75f, 1.0f) positionOffset:ccp(map2.contentSize.width-1, 90)];
    [node addChild:map3 z:-3 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:ccp(0,100)];
    [node addChild:map3_1 z:-3 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:ccp(map3.contentSize.width-1, 100)];
    
    [self addChild:node];
    
    self.contentSize = CGSizeMake(map1.contentSize.width*2, map1.contentSize.height);
}

-(void)addEntity:(Entity *)entity {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    NSAssert(render, @"Need render component to add on map!");
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfName:[CharacterComponent name]];
    
    CGPoint position;
    
    if (character) {
        if (team.team == 1) {
            position = ccp(kMapStartDistance, arc4random_uniform(kMapPathRandomHeight) + kMapPathFloor);
        } else {
            position = ccp(self.boundaryX - kMapStartDistance, arc4random_uniform(kMapPathRandomHeight) + kMapPathFloor);
        }
    } else {
        // castle
        if (team.team == 1) {
            position = ccp(kMapStartDistance - render.sprite.boundingBox.size.width/4, kMapPathFloor);
        } else {
            position = ccp(self.boundaryX - kMapStartDistance + render.sprite.boundingBox.size.width/4, kMapPathFloor);
        }
    }
    [self addEntity:entity toPosition:position];
}

@end
