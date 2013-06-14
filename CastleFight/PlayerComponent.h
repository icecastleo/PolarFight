//
//  PlayerComponent.h
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "Component.h"

@interface PlayerComponent : Component {
    
}

@property float food;
@property (nonatomic) float foodRate;
@property (readonly) float maxRate;

@property (readonly) float interval;
@property float foodAddend;

@property float delta;

@property NSMutableArray *summonComponents;
@property (nonatomic) NSMutableArray *battleTeam;

@end
