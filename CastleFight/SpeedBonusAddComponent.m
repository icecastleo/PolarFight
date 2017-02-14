//
//  SpeedBonusAddComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/7.
//
//

#import "SpeedBonusAddComponent.h"
#import "Attribute.h"

@implementation SpeedBonusAddComponent

+(NSString *)name {
    static NSString *name = @"SpeedBonusAddComponent";
    return name;
}

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
        [self.attribute addBonus:self.bonus];
        _isExecuting = YES;
    }
}

-(void)dealloc {
    [self.attribute subtractBonus:self.bonus];
}

@end
