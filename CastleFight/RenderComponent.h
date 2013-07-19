//
//  RenderComponent.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"
#import "cocos2d.h"

@interface RenderComponent : Component {
    CGPoint shadowOffset;
}

// Used for position
@property (readonly) CCNode *node;
@property CGPoint position;

// Used for animation
@property (readonly) CCSprite *sprite;
// Fix boundingbox for map to calculate boundary, can be remove if box2d enable
@property (readonly) CGRect spriteBoundingBox;

@property (nonatomic) BOOL enableShadowPosition;
@property (readonly) CGSize shadowSize;

//test spine
@property (nonatomic) BOOL isSpineNode;
//@property (nonatomic) CCNode *spineNode;
//test spine


-(id)initWithSprite:(CCSprite *)sprite;
-(id)initWithSpineNode:(CCNode *)spineNode;

-(void)addFlashString:(NSString *)string color:(ccColor3B)color;

-(void)stopAnimation;
-(void)flip;

@end
