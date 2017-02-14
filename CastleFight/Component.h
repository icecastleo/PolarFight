//
//  Component.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Entity.h"

@interface Component : NSObject<EntityEventDelegate>

@property Entity *entity;

//+(NSNumber *)type;
+(NSString *)name;

-(void)sendEvent:(EntityEvent)type Message:(id)message;

@end
