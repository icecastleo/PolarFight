//
//  Attribute.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/12.
//
//

#import "Attribute.h"
#import "Character.h"
#import "AttributeFactory.h"

@implementation Attribute

@dynamic currentValue;

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

//-(void)addDependentAttribute {
//    dependent = [[DependentAttribute alloc] initWithAttribute:self];
//}

-(void)increaseCurrentValue:(int)aValue {
    NSAssert(_dependent != nil, @"Try to use current value without a dependent attribute");
    
    [_dependent increaseValue:aValue];
}

-(void)decreaseCurrentValue:(int)aValue {
    NSAssert(_dependent != nil, @"Try to use current value without a dependent attribute");
    
    [_dependent decreaseValue:aValue];
}

-(int)currentValue {
    NSAssert(_dependent != nil, @"Try to use current value without a dependent attribute");
    
    return _dependent.value;
}

-(id)initWithDom:(GDataXMLElement *)dom {
    CharacterAttribute characterType;
    int tempQuadratic = 0;
    int tempLinear = 0;
    int tempConstantTerm = 0;
    
    for (GDataXMLNode *attribute in dom.attributes) {
        NSLog(@"attribute.name :: %@",attribute.name);
        NSLog(@"attribute.value :: %@",attribute.stringValue);
        
        if ([attribute.name isEqualToString:@"name"]) {
            characterType = [self getCharacterTypeFromAttributeName:attribute.stringValue];
        }else if ([attribute.name isEqualToString:@"a"]) {
            tempQuadratic = attribute.stringValue.intValue;
        }else if ([attribute.name isEqualToString:@"b"]) {
            tempLinear = attribute.stringValue.intValue;
        }else if ([attribute.name isEqualToString:@"c"]) {
            tempConstantTerm = attribute.stringValue.intValue;
        }
    }
    self = [AttributeFactory createAttributeWithType:characterType withQuadratic:tempQuadratic withLinear:tempLinear withConstantTerm:tempConstantTerm];
    return self;
}

-(CharacterAttribute)getCharacterTypeFromAttributeName:(NSString *)attributeName {
    if([attributeName isEqualToString:@"maxHp"])
    {
        return kCharacterAttributeHp;
    }else if ([attributeName isEqualToString:@"hp"]){
        
    }
    
    return nil;
}
@end
