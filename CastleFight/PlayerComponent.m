//
//  PlayerComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "PlayerComponent.h"

@interface PlayerComponent() {
    NSMutableDictionary *counts;
}
@end

@implementation PlayerComponent

+(NSString *)name {
    static NSString *name = @"PlayerComponent";
    return name;
}

-(id)init {
    if ((self = [super init])) {
        counts = [[NSMutableDictionary alloc] init];
        
        _food = 10.0;
//        _foodRate = 1.0;
//        _maxRate = _foodRate * 4;
//        
        _mana = 10.0;
//        _manaRate = 1.0;
//        _maxManaRate = _manaRate * 4;
        
        _interval = 0.25;
        
        _summonComponents = [[NSMutableArray alloc] init];
        _battleTeam = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)addCount:(int)count onOrbColor:(OrbColor)color; {
    NSNumber *key = [NSNumber numberWithInt:color];
    NSNumber *number = [counts objectForKey:key];
    
    if (number == nil) {
        number = [NSNumber numberWithInt:0];
        [counts setObject:number forKey:key];
    }
    
    [counts setObject:[NSNumber numberWithInt:[number intValue]+count] forKey:key];
}

-(NSMutableDictionary *)getCalculatedArmies {
    NSMutableDictionary *armies = [[NSMutableDictionary alloc] init];
    
    //    for (id key in counts.allKeys) {
    //        int type = [key intValue];
    //        int count = [[counts objectForKey:key] intValue];
    //
    //        // FIXME: Link cid with user data's battle team
    //        [armies setObject:[NSNumber numberWithInt:count/3] forKey:[NSString stringWithFormat:@"00%d",type]];
    //    }
    
    [armies setObject:[NSNumber numberWithInt:5] forKey:@"001"];
    [armies setObject:[NSNumber numberWithInt:5] forKey:@"002"];
    [armies setObject:[NSNumber numberWithInt:5] forKey:@"003"];
    [armies setObject:[NSNumber numberWithInt:5] forKey:@"004"];
    
    return armies;
}


//-(void)setFoodRate:(float)foodRate {
//    if (foodRate > _maxRate) {
//        _foodRate = _maxRate;
//    } else {
//        _foodRate = foodRate;
//    }
//}
//
//-(void)setManaRate:(float)manaRate {
//    if (manaRate > _maxManaRate) {
//        _manaRate = _maxManaRate;
//    } else {
//        _manaRate = manaRate;
//    }
//}

@end
