//
//  PlayerArmyComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/11.
//
//

#import "PlayerArmyComponent.h"
#import "FileManager.h"

@interface PlayerArmyComponent() {
    NSMutableDictionary *counts;
}
@end

@implementation PlayerArmyComponent

+(NSString *)name {
    static NSString *name = @"PlayerArmyComponent";
    return name;
}

-(id)init {
    if (self = [super init]) {
        counts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)addCount:(int)count onOrbType:(OrbType)type {
    NSNumber *key = [NSNumber numberWithInt:type];
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

@end
