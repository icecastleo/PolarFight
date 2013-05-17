//
//  BattleCatMapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "BattleCatMapLayer.h"
#import "HeroAI.h"

@implementation BattleCatMapLayer

-(id)initWithName:(NSString *)name {
    if (self = [super initWithName:name]) {
//        _hero = [[Character alloc] initWithId:@"209" andLevel:1];
//        _hero.player = 1;
//        [_hero.sprite addBloodSprite];
//        [self addCharacter:_hero];
//        _hero.ai = [[HeroAI alloc] initWithCharacter:_hero];
    }
    return self;
}

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
    [node addChild:map1_1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(map1.boundingBox.size.width-1, 0)];
    [node addChild:map2 z:-2 parallaxRatio:ccp(0.75f, 1.f) positionOffset:ccp(0,90)];
    [node addChild:map2_1 z:-2 parallaxRatio:ccp(0.75f, 1.0f) positionOffset:ccp(map2.boundingBox.size.width-1, 90)];
    [node addChild:map3 z:-3 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:ccp(0,100)];
    [node addChild:map3_1 z:-3 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:ccp(map3.boundingBox.size.width-1, 100)];
    
    [self addChild:node];
    
    self.contentSize = CGSizeMake(map1.boundingBox.size.width*2, map1.boundingBox.size.height);
}

//-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    isMove = NO;
//    return YES;
//}
//
//-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
//    isMove = YES;
//    
//    CGPoint location = [touch locationInView:touch.view];
//    location = [[CCDirector sharedDirector] convertToGL:location];
//    
//    CGPoint lastLocation = [touch previousLocationInView:touch.view];
//    lastLocation = [[CCDirector sharedDirector] convertToGL:lastLocation];
//    
//    CGPoint diff = ccpSub(lastLocation, location);
//    
//    [self.cameraControl moveBy:ccpMult(diff, 0.5)];
//    
//    if (isFollow) {
//        isFollow = NO;
//        [self.cameraControl stopFollow];
//    }
//}
//
//-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
//    // map location
//    CGPoint location = [self convertTouchToNodeSpace:touch];
//    
//    //    // win location
//    //    location = [touch locationInView:[CCDirector sharedDirector].view];
//    //    location = [[CCDirector sharedDirector] convertToGL: location];
//    
//    if (!isMove) {
//        _hero.ai.targetPoint = location;
//        
//        if (isFollow == NO) {
//            isFollow = YES;
//            [self.cameraControl followCharacter:_hero];
//        }
//    }
//}


@end
