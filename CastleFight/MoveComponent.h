//
//  MoveComponent.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"
#import "Attribute.h"
@class RenderComponent;

@interface MoveComponent : Component

@property (readonly) Attribute *speed;
@property (nonatomic) CGPoint velocity;

-(id)initWithSpeedAttribute:(Attribute *)speed;

@end
