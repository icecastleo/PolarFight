//
//  DefenderComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/4.
//
//

#import "DefenderComponent.h"

@implementation DefenderComponent

+(NSString *)name {
    static NSString *name = @"DefenderComponent";
    return name;
}

-(id)initWithHpAttribute:(Attribute *)hp {
    if (self = [super init]) {
        _hp = hp;
        _damageEventQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventLevelChanged) {
        [_hp updateValueWithLevel:[message intValue]];
        [_defense updateValueWithLevel:[message intValue]];
    }
}

@end
