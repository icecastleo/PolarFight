//
//  Component.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Entity.h"
#import "EntityEventDelegate.h"

@interface Component : NSObject<EntityEventDelegate>

@property Entity *entity;

-(void)sendEvent:(EventType)type Message:(id)message;

@end
