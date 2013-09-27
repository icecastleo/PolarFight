//
//  AliveComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/9/24.
//
//

#import "AliveComponent.h"

@implementation AliveComponent

+(NSString *)name {
    static NSString *name = @"AliveComponent";
    return name;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventDead) {
        _isDead = YES;
    } else if (type == kEntityEventRevive) {
        _isDead = NO;
    }
}

@end
