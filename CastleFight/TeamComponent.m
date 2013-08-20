//
//  TeamComponent.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "TeamComponent.h"

@implementation TeamComponent

+(NSString *)name {
    static NSString *name = @"TeamComponent";
    return name;
}

-(id)initWithTeam:(int)team {
    if ((self = [super init])) {
        _team = team;
    }
    return self;
}

@end
