//
//  Attribute.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/12.
//
//

#import "Attribute.h"
#import "Character.h"

@implementation Attribute

@synthesize value;

-(id)initWithQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c {
    if(self = [super init]) {
        quadratic = a;
        linear = b;
        constantTerm = c;
        
        bonus = 0;
        multiplier = 1;
        
        [self updateValueWithLevel:1];
    }
    return self;
}

-(void)addBonus:(int)aBonus {
    bonus += aBonus;
    [self updateValue];
}

-(void)subtractBonus:(int)aBonus {
    bonus -= aBonus;
    [self updateValue];
}

-(void)addMultiplier:(float)aMultiplier {
    multiplier *= multiplier;
    [self updateValue];
}

-(void)subtractMultiplier:(float)aMultiplier {
    multiplier /= multiplier;
    [self updateValue];
}

-(void)updateValue {
    value = (baseValue + bonus) * multiplier;
}

-(void)updateValueWithLevel:(int)level {
    baseValue = quadratic * pow(level, 2) + linear * level + constantTerm;
    [self updateValue];
}

@end
