//
//  Attribute.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/12.
//
//

#import "Attribute.h"
#import "AccumulateAttribute.h"

@implementation Attribute

@dynamic currentValue;

-(id)initWithQuadratic:(float)a linear:(float)b constantTerm:(float)c isFluctuant:(BOOL)isFluctuant {
    if(self = [super init]) {
        quadratic = a;
        linear = b;
        constantTerm = c;
        
        bonus = 0;
        multiplier = 1;
        
        if (isFluctuant) {
            fluctuant = [[FluctuantAttribute alloc] initWithAttribute:self];
        }
        
        // Set default value
        [self updateValueWithLevel:0];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    float a;
    float b;
    float c = [[dic objectForKey:@"c"] intValue];
    
    NSRange range = [[dic objectForKey:@"b"] rangeOfString:@"c"];
    
    if (range.location != NSNotFound) {
        float temp = [[[dic objectForKey:@"b"] substringToIndex:range.location] floatValue];
        b = temp * c;
    } else {
        b = [[dic objectForKey:@"b"] intValue];
    }
    
    range = [[dic objectForKey:@"a"] rangeOfString:@"c"];
    
    if (range.location != NSNotFound) {
        float temp = [[[dic objectForKey:@"a"] substringToIndex:range.location] floatValue];
        a = temp * c;
    } else {
        range = [[dic objectForKey:@"a"] rangeOfString:@"b"];
        
        if (range.location != NSNotFound) {
            float temp = [[[dic objectForKey:@"a"] substringToIndex:range.location] floatValue];
            a = temp * b;
        } else {
            a = [[dic objectForKey:@"a"] intValue];
        }
    }
    
    BOOL isFluctuant = [[dic objectForKey:@"isFluctuant"] boolValue];
     
    return [self initWithQuadratic:a linear:b constantTerm:c isFluctuant:isFluctuant];
}

-(void)addBonus:(float)aBonus {
    bonus += aBonus;
    [self updateValue];
    
    if (fluctuant != nil) {
        fluctuant.value += aBonus * multiplier;
    }
}

-(void)subtractBonus:(float)aBonus {
    bonus -= aBonus;
    [self updateValue];
    
    if(fluctuant != nil) {
        fluctuant.value = MAX(1, fluctuant.value - aBonus * multiplier);
    }
}

-(void)addMultiplier:(float)aMultiplier {
    NSAssert(aMultiplier > 0, @"You can't set a multiplier <= 0");
    
    multiplier *= aMultiplier;
    [self updateValue];
    
    if(fluctuant != nil) {
        fluctuant.value *= multiplier;
    }
}

-(void)subtractMultiplier:(float)aMultiplier {
    NSAssert(aMultiplier > 0, @"You can't set a multiplier <= 0");
    
    multiplier /= aMultiplier;
    [self updateValue];
    
    if(fluctuant != nil) {
        fluctuant.value /= multiplier;
    }
}

-(void)updateValue {
    _value = roundf((baseValue + bonus) * multiplier);
}

-(int)valueWithLevel:(int)level {
    return quadratic * pow(level, 2) + linear * level + constantTerm;
}

-(void)updateValueWithLevel:(int)level {
    baseValue = [self valueWithLevel:level];
    [self updateValue];
    
    // Set to max when level change
    fluctuant.value = _value;
}

-(void)setCurrentValue:(int)currentValue {
    NSAssert(fluctuant != nil, @"Try to use current value without a dependent attribute");
    
    fluctuant.value = currentValue;
}

-(int)currentValue {
    NSAssert(fluctuant != nil, @"Try to use current value without a dependent attribute");
    
    return fluctuant.value;
}

@end
