//
//  MagicComponent.m
//  CastleFight
//
//  Created by  DAN on 13/7/2.
//
//

#import "MagicComponent.h"

@implementation MagicComponent

-(id)initWithDamageAttribute:(Attribute *)damage andMagicName:(NSString*)name andNeedImages:(NSDictionary *)images {
    if (self = [super init]) {
        _damage = damage;
        _name = name;
        _images = images;
    }
    return self;
}

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventTypeLevelChanged) {
        [_damage updateValueWithLevel:[message intValue]];
    }
}

@end
