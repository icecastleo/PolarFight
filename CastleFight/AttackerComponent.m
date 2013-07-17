//
//  AttackerComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/5.
//
//

#import "AttackerComponent.h"
#import "AttackEvent.h"

@implementation AttackerComponent

-(id)initWithAttackAttribute:(Attribute *)attack {
    if (self = [super init]) {
        _attack = attack;
        _attackEventQueue = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEntityEventLevelChanged) {
        [_attack updateValueWithLevel:[message intValue]];
    }
}

@end
