//
//  RenderComponent.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"
#import "cocos2d.h"

@interface RenderComponent : Component

@property CGPoint position;
@property CCSprite *sprite;

-(id)initWithSprite:(CCSprite *)sprite;

-(void)addFlashString:(NSString *)string color:(ccColor3B)color;

@end
