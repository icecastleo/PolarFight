//
//  ExpendableAttribute.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/13.
//
//

#import "FluidAttribute.h"

@implementation FluidAttribute

-(id)initWithQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c {
    if(self = [super initWithQuadratic:a withLinear:b withConstantTerm:c]) {
        currentValue = self.value;
    }
    return self;
}

-(void)addBonus:(int)aBonus {
    [super addBonus:aBonus];
    currentValue += aBonus * multiplier;
}

-(void)subtractBonus:(int)aBonus {
    [super subtractBonus:aBonus];
    currentValue = MAX(1, currentValue - aBonus * multiplier);
}

-(void)addMultiplier:(float)aMultiplier {
    [super addMultiplier:aMultiplier];
    currentValue *= aMultiplier;
}

-(void)subtractMultiplier:(float)aMultiplier {
    [super subtractMultiplier:aMultiplier];
    currentValue /= aMultiplier;
}

-(void)adjustValue:(int)aValue {
    if(aValue > 0 ) {
        currentValue = MIN(self.value, currentValue + aValue);
    } else {
        currentValue = MAX(0, currentValue + aValue);
    }
}

@end
