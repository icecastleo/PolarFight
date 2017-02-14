//
//  GroupComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/25.
//
//

#import "GroupComponent.h"

@implementation GroupComponent

+(NSString *)name {
    static NSString *name = @"GroupComponent";
    return name;
}

-(id)initWithGroupArray:(NSMutableArray *)entities {
    if (self = [super init]) {
        _groupEntities = entities;
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventDead) {
        [_groupEntities removeObject:self.entity];
    }
}

@end
