//
//  BattleSetObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/5.
//
//

#import "BattleSetObject.h"

@implementation BattleSetObject

-(id)initWithBattleName:(NSString *)name {
    
    if (self = [super init]) {
        _sceneName = name;
    }
    return self;
}

@end
