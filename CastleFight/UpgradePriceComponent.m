//
//  UpgradePriceComponent.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/6.
//
//

#import "UpgradePriceComponent.h"

@implementation UpgradePriceComponent

-(id)initWithPriceComponent:(Attribute *)price {
    if (self = [super init]) {
        _price = price;
    }
    return self;
}

-(void)receiveEvent:(EventType)type Message:(id)message {
    if (type == kEventTypeLevelChanged) {
        [_price updateValueWithLevel:[message intValue]];
    }
}


@end
