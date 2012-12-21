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

@dynamic currentValue;

-(id)initWithType:(CharacterAttributeType)aType withQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c {
    if(self = [super init]) {
        _type = aType;
        
        quadratic = a;
        linear = b;
        constantTerm = c;
        
        bonus = 0;
        multiplier = 1;
        
        [self updateValueWithLevel:1];
        
        if (_type < kCharacterAttributeBoundary) {
            _dependent = [[DependentAttribute alloc] initWithAttribute:self];
        }
    }
    return self;
}

-(void)addBonus:(int)aBonus {
    bonus += aBonus;
    [self updateValue];
    
    if (_dependent != nil) {
        _dependent.value += aBonus * multiplier;
    }
}

-(void)subtractBonus:(int)aBonus {
    bonus -= aBonus;
    [self updateValue];
    
    if(_dependent != nil) {
        _dependent.value = MAX(1, _dependent.value - aBonus * multiplier);
    }
}

-(void)addMultiplier:(float)aMultiplier {
    multiplier *= multiplier;
    [self updateValue];
    
    if(_dependent != nil) {
        _dependent.value *= multiplier;
    }
}

-(void)subtractMultiplier:(float)aMultiplier {
    multiplier /= multiplier;
    [self updateValue];
    
    if(_dependent != nil) {
        _dependent.value /= multiplier;
    }
}

-(void)updateValue {
    _value = (baseValue + bonus) * multiplier;
}

-(void)updateValueWithLevel:(int)level {
    baseValue = quadratic * pow(level, 2) + linear * level + constantTerm;
    [self updateValue];
}

-(void)increaseCurrentValue:(int)aValue {
    NSAssert(_dependent != nil, @"Try to use current value without a dependent attribute");
    
    [_dependent increaseValue:aValue];
}

-(void)decreaseCurrentValue:(int)aValue {
    NSAssert(_dependent != nil, @"Try to use current value without a dependent attribute");
    
    [_dependent decreaseValue:aValue];
}

-(void)setCurrentValue:(int)currentValue {
    NSAssert(_dependent != nil, @"Try to use current value without a dependent attribute");
    
    _dependent.value = currentValue;
}

-(int)currentValue {
    NSAssert(_dependent != nil, @"Try to use current value without a dependent attribute");
    
    return _dependent.value;
}
@end
