//
//  DependentAttribute.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/15.
//
//

#import "DependentAttribute.h"
#import "Attribute.h"

@implementation DependentAttribute

-(id)initWithAttribute:(Attribute *)anAttribute {
    if(self = [super init]) {
        father = anAttribute;
        _value = father.value;
    }
    return self;
}

-(void)increaseValue:(int)aValue {
    _value = MIN(father.value, _value + aValue);
}

-(void)decreaseValue:(int)aValue {
    _value = MAX(0, _value - aValue);
}

-(void)setValue:(int)value {    
    NSAssert(father.value >= value && value >= 0, @"Set current value out of its range.");
    
    _value = value;
}

@end
