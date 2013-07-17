//
//  LevelComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/2.
//
//

#import "LevelComponent.h"

@interface LevelComponent() {
    NSMutableDictionary *_attributes;
}

@end

@implementation LevelComponent

-(id)initWithLevel:(int)level {
    if (self = [super init]) {
        self.level = level;
    }
    return self;
}

-(void)setLevel:(int)level {
    _level = level;

    [self sendEvent:kEntityEventLevelChanged Message:[NSNumber numberWithInt:level]];
}

-(void)setEntity:(Entity *)entity {
    [super setEntity:entity];
    [self sendEvent:kEntityEventLevelChanged Message:[NSNumber numberWithInt:_level]];
}

@end
