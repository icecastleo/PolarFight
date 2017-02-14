//
//  AttackBonusMultiplierComponent.m
//  CastleFight
//
//  Created by  浩翔 on 13/6/7.
//
//

#import "AttackBonusMultiplierComponent.h"
#import "Attribute.h"

@implementation AttackBonusMultiplierComponent

+(NSString *)name {
    static NSString *name = @"AttackBonusMultiplierComponent";
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
        [self.attribute addMultiplier:self.bonus];
        _isExecuting = YES;
    }
}

-(void)dealloc {
    [self.attribute subtractMultiplier:self.bonus];
}

@end
