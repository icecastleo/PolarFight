//
//  BattleDataObject.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/18.
//
//

#import "BattleDataObject.h"

@implementation BattleDataObject

-(id)initWithBattleName:(NSString *)name {
    
    if (self = [super init]) {
        _sceneName = name;
    }
    return self;
}

@end
