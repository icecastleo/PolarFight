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
        
        if (_type < kCharacterAttributeFluidBoundary) {
            _dependent = [[DependentAttribute alloc] initWithAttribute:self];
        }
        
        // For castle fight game
        if (_type < kCharacterAttributeSpecialBoundary) {
            b = 0.02 * c;
        }
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    CharacterAttributeType attributeType = [self getAttributeTypeFromAttributeName:[dic objectForKey:@"name"]];
    int tempQuadratic = [[dic objectForKey:@"a"] intValue];
    int tempLinear = [[dic objectForKey:@"b"] intValue];
    int tempConstantTerm = [[dic objectForKey:@"c"] intValue];
    
    return [self initWithType:attributeType withQuadratic:tempQuadratic withLinear:tempLinear withConstantTerm:tempConstantTerm];
}

-(CharacterAttributeType)getAttributeTypeFromAttributeName:(NSString *)attributeName {
    if([attributeName isEqualToString:@"maxHp"]) {
        return kCharacterAttributeHp;
    } else if ([attributeName isEqualToString:@"maxMp"]) {
        return kCharacterAttributeMp;
    } else if ([attributeName isEqualToString:@"attack"]) {
        return kCharacterAttributeAttack;
    } else if ([attributeName isEqualToString:@"defense"]) {
        return kCharacterAttributeDefense;
    } else if ([attributeName isEqualToString:@"agile"]) {
        return kCharacterAttributeAgile;
    } else if ([attributeName isEqualToString:@"speed"]) {
        return kCharacterAttributeSpeed;
    } else if ([attributeName isEqualToString:@"moveTime"]) {
        return kCharacterAttributeTime;
    } else if ([attributeName isEqualToString:@"updatePrice"]) {
        return kCharacterAttributeUpdatePrice;
    } else {
        [NSException raise:@"Invalid attribute name" format:@"Unknown attribute %@",attributeName];
        return -1;
    }
}

-(void)addBonus:(float)aBonus {
    bonus += aBonus;
    [self updateValue];
    
    if (_dependent != nil) {
        _dependent.value += aBonus * multiplier;
    }
}

-(void)subtractBonus:(float)aBonus {
    bonus -= aBonus;
    [self updateValue];
    
    if(_dependent != nil) {
        _dependent.value = MAX(1, _dependent.value - aBonus * multiplier);
    }
}

-(void)addMultiplier:(float)aMultiplier {
    NSAssert(aMultiplier > 0, @"You can't set a multiplier <= 0");
    
    multiplier *= aMultiplier;
    [self updateValue];
    
    if(_dependent != nil) {
        _dependent.value *= multiplier;
    }
}

-(void)subtractMultiplier:(float)aMultiplier {
    NSAssert(aMultiplier > 0, @"You can't set a multiplier <= 0");
    
    multiplier /= aMultiplier;
    [self updateValue];
    
    if(_dependent != nil) {
        _dependent.value /= multiplier;
    }
}

-(void)updateValue {
    _value = roundf((baseValue + bonus) * multiplier);
}

-(void)updateValueWithLevel:(int)level {
    baseValue = quadratic * pow(level, 2) + linear * level + constantTerm;
    [self updateValue];
    
    // Set to max when level change
    _dependent.value = _value;
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
