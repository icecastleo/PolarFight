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

-(void)setMap:(NSString *)name {
  
    CCParallaxNode *node = [CCParallaxNode node];
    int repeat = 3;
    
    CCSprite *preloadMap = [CCSprite spriteWithFile:@"ice.png"];
    int width = preloadMap.boundingBox.size.width;
    int height = preloadMap.boundingBox.size.height;
    
    for(int i = 0; i < repeat; i++) {
        CCSprite *map = [CCSprite spriteWithFile:@"ice.png"];
        map.anchorPoint = ccp(0, 0);
        [node addChild:map z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp((width-1)*i, 0)];
    }

    [self addChild:node];
    self.contentSize = CGSizeMake(width*repeat, height);
}

-(void)addEntity:(Entity *)entity {
    int line = arc4random_uniform(kMapPathMaxLine);
    [self addEntity:entity line:line];
}

-(void)addEntity:(Entity *)entity line:(int)line {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    NSAssert(render, @"Need render component to add on map!");
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    
    CGPoint position;
    
    if (character) {
        if (team.team == 1) {
            position = ccp(kMapStartDistance, kMapPathFloor + line*kMapPathHeight + arc4random_uniform(kMapPathRandomHeight));
        } else {
            position = ccp(self.boundaryX - kMapStartDistance, kMapPathFloor + line*kMapPathHeight + arc4random_uniform(kMapPathRandomHeight));
        }
    } else {
        // castle
        if (team.team == 1) {
            position = ccp(kMapStartDistance - render.sprite.boundingBox.size.width/4, kMapPathFloor + kMapPathHeight/2);
        } else {
            position = ccp(self.boundaryX - kMapStartDistance + render.sprite.boundingBox.size.width/4, kMapPathFloor + kMapPathHeight/2);
        }
    }
    [self addEntity:entity toPosition:position];
}

@end
