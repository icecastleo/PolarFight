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
    CGPoint offset;
    CGPoint shadowOffset;
}

// Used for position
@property CCNode *node;
@property CGPoint position;

// Used for animation
@property CCSprite *sprite;

@property (nonatomic) BOOL enableShadowPosition;
@property (readonly) CCSprite *shadow;

//test spine
@property (nonatomic) BOOL isSpineNode;
//@property (nonatomic) CCNode *spineNode;
//test spine


-(id)initWithSprite:(CCSprite *)sprite;
-(id)initWithSpineNode:(CCNode *)spineNode;

-(void)addFlashString:(NSString *)string color:(ccColor3B)color;
-(void)addShadow;

-(void)stopAnimation;
-(void)flip;

@end
