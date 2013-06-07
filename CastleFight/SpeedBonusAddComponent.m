//
//  SpeedBonusAddComponent.m
//  CastleFight
//
//  Created by  DAN on 13/6/7.
//
//

#import "SpeedBonusAddComponent.h"
#import "Attribute.h"

@implementation SpeedBonusAddComponent

-(id)initWithAttribute:(Attribute *)attribute andBonus:(float)bonus {
    if (self = [super init]) {
        _attribute = attribute;
        _bonus = bonus;
        _isExecuting = NO;
    }
    return self;
}

-(void)process {
    if (!self.isExecuting) {
        NSLog(@"1.attribute:%d",self.attribute.value);
        [self.attribute addBonus:self.bonus];
        NSLog(@"2.attribute:%d",self.attribute.value);
        _isExecuting = YES;
    }
}

-(void)dealloc {
    [self.attribute subtractBonus:self.bonus];
}

@end
