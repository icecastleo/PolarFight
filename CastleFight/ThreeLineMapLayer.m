//
//  ThreeLineMapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "ThreeLineMapLayer.h"

@implementation ThreeLineMapLayer

-(void)setMap:(NSString *)name {
    CCSprite *map1 = [CCSprite spriteWithFile:@"background.png"];
    map1.anchorPoint = ccp(0, 0);
    CCSprite *map1_1 = [CCSprite spriteWithFile:@"background.png"];
    map1_1.anchorPoint = ccp(0, 0);
    
    CCParallaxNode *node = [CCParallaxNode node];
    
    [node addChild:map1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(0,0)];
    [node addChild:map1_1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(map1.boundingBox.size.width-1, 0)];
    
    [self addChild:node];
    
    self.contentSize = CGSizeMake(map1.boundingBox.size.width*2, map1.boundingBox.size.height);
}

@end
