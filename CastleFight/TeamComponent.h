//
//  TeamComponent.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"

@interface TeamComponent : Component

@property int team;

-(id)initWithTeam:(int)team;

@end
