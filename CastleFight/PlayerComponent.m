//
//  PlayerComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "PlayerComponent.h"

@implementation PlayerComponent

-(id)init {
    if ((self = [super init])) {
        _food = 10.0;
        _foodRate = 1.0;
        _maxRate = _foodRate * 4;
        
        _interval = 0.25;
        _foodAddend = 0.05;
        
        _summonComponents = [[NSMutableArray alloc] init];
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

@end
