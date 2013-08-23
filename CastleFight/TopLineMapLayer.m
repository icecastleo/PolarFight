//
//  TopLineMapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/8/23.
//
//

#import "TopLineMapLayer.h"
#import "CharacterComponent.h"
#import "RenderComponent.h"
#import "TeamComponent.h"

@implementation TopLineMapLayer

-(void)setMap:(NSString *)name {
    CCParallaxNode *node = [CCParallaxNode node];
    
    CCSprite *temp = [CCSprite spriteWithFile:@"christmas.png"];
    int width = temp.contentSize.width;
    int height = temp.contentSize.height;
    
    int repeat = 1;
    
    for(int i = 0; i < repeat; i++) {
        CCSprite *map = [CCSprite spriteWithFile:@"christmas.png"];
        map.anchorPoint = ccp(0, 0);
        [node addChild:map z:0 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp((width-1)*i, 35)];
    }
    
    [self addChild:node z:-5];
    self.contentSize = CGSizeMake(width*repeat, height);
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CCLayerColor *layer = [CCLayerColor layerWithColor:ccc4(ccBLACK.r, ccBLACK.g, ccBLACK.b, 127) width:winSize.width height:winSize.height/2];
    [self addChild:layer z:-1];
}

-(void)addEntity:(Entity *)entity {
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfName:[CharacterComponent name]];
    
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    NSAssert(render, @"Need render component to add on map!");
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfName:[TeamComponent name]];
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    if (character) {
        CGPoint position;
        
        if (team.team == 1) {
            position = ccp(kMapStartDistance, kMapPathFloor + arc4random_uniform(kMapPathRandomHeight));
        } else {
            position = ccp(winSize.width - kMapStartDistance, kMapPathFloor + arc4random_uniform(kMapPathRandomHeight));
        }
        [self addEntity:entity toPosition:position];
    } else {
        // castle
        if (team.team == 1) {
            render.position = ccp(kMapStartDistance - render.sprite.boundingBox.size.width/2, kMapPathFloor);
        } else {
            render.position = ccp(winSize.width - kMapStartDistance + render.sprite.boundingBox.size.width/2, kMapPathFloor);
        }
        
        [self addChild:render.node];
    }
}

@end
