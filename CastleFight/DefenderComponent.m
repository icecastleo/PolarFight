//
//  DefenderComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/4.
//
//

#import "DefenderComponent.h"

@implementation DefenderComponent

-(id)initWithHpAttribute:(Attribute *)hp {
    if (self = [super init]) {
        _hp = hp;
        _damageEventQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventTypeLevelChanged) {
        [_hp updateValueWithLevel:[message intValue]];
        [_defense updateValueWithLevel:[message intValue]];
    } else if (type == kEventReceiveDamage) {
        [_bloodSprite update];
    }
}

@end
