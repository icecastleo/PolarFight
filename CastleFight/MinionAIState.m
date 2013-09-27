//
//  MinionAIState.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/16.
//
//

#import "MinionAIState.h"

@implementation MinionAIState

-(id)initWithGeneral:(Entity *)general {
    if (self = [super init]) {
        _general = general;
    }
    return self;
}

@end
