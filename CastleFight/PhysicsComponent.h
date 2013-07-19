//
//  PhysicsComponent.h
//  CastleFight
//
//  Created by 朱 世光 on 13/7/19.
//
//

#import "Component.h"
#import "PhysicsSystem.h"
#import "PhysicsRoot.h"
#import "DirectionComponent.h"
#import "RenderComponent.h"

@interface PhysicsComponent : Component

@property (readonly) PhysicsSystem *system;
@property (readonly) PhysicsRoot *root;

@property DirectionComponent *direction;

-(id)initWithPhysicsSystem:(PhysicsSystem *)system renderComponent:(RenderComponent *)render;

@end
