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

@property NSDictionary *remainArmies;

-(void)addCount:(int)count onOrbColor:(OrbColor)color;
-(NSMutableDictionary *)getCalculatedArmies;
-(NSDictionary *)orbInfo;

@property float food;
@property (nonatomic) float foodRate;
@property (readonly) float maxRate;

@property float mana;
@property (nonatomic) float manaRate;
@property (readonly) float maxManaRate;

@property (readonly) float interval;
@property float delta;

@property NSMutableArray *summonComponents;
@property (nonatomic) NSMutableArray *battleTeam;

@property int armiesCount;

@end
