//
//  PlayerComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "PlayerComponent.h"

@implementation PlayerComponent

+(NSString *)name {
    static NSString *name = @"PlayerComponent";
    return name;
}

-(id)init {
    if ((self = [super init])) {
        _food = 10.0;
        _foodRate = 0.0;
        _maxRate = _foodRate * 4;
        
        _mana = 10.0;
        _manaRate = 1.0;
        _maxManaRate = _manaRate * 4;
        
        _interval = 0.25;
        _foodAddend = 0.05;
        
        _summonComponents = [[NSMutableArray alloc] init];
        _battleTeam = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)setFoodRate:(float)foodRate {
    if (foodRate > _maxRate) {
        _foodRate = _maxRate;
    } else {
        _foodRate = foodRate;
    }
}

-(void)setManaRate:(float)manaRate {
    if (manaRate > _maxManaRate) {
        _manaRate = _maxManaRate;
    } else {
        _manaRate = manaRate;
    }
}

@end
