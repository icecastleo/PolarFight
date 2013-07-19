//
//  RenderComponent.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"
#import "cocos2d.h"
#import "PhysicsSystem.h"
#import "PhysicsRoot.h"

@interface RenderComponent : Component {
    CGPoint shadowOffset;
}

// Used for position
@property (readonly) CCNode *node;
@property CGPoint position;

// Used for animation
@property (readonly) CCNode *sprite;
// Fix boundingbox for map to calculate boundary, can be remove if box2d enable
@property (readonly) CGRect spriteBoundingBox;

@property (readonly) PhysicsRoot *physicsRoot;

@property (nonatomic) BOOL enableShadowPosition;
@property (readonly) CGSize shadowSize;

@property PhysicsSystem *physicsSystem;

@property (nonatomic) BOOL isSpineNode;


-(id)initWithSprite:(CCNode *)sprite;

-(void)addFlashString:(NSString *)string color:(ccColor3B)color;

-(void)stopAnimation;
-(void)flip:(Direction)direction;

@end
