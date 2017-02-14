//
//  Property.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//


#import "Property.h"

#define kName       @"name"
#define kValue      @"value"
#define kActivation       @"activation"
#define kInitialValue      @"initialValue"
#define kActivationValue       @"activationValue"
#define kTags      @"tags"

@interface Property()

@property int activationValue;
@property int initialValue;

@end

@implementation Property

-(id)initWithPropertyName:(NSString *)name InitialValue:(int)initialValue theActivationMode:(NSString *)activation ActivationValue:(int)activationValue tags:(NSArray *)tags {
    
    if (self = [super init]) {
        _name = name;
        _initialValue = initialValue;
        _activation = activation;
        _activationValue = activationValue;
        _tags = tags;
        
        [self reset];
    }
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dic {
    if (self = [super init]) {
        _name = [dic objectForKey:kName];
        _value = [[dic objectForKey:kValue] intValue];
        _activation = [dic objectForKey:kActivation];
        _initialValue = [[dic objectForKey:kInitialValue] intValue];
        _activationValue = [[dic objectForKey:kActivationValue] intValue];
        _tags = [dic objectForKey:kTags];
    }
    return self;
}

-(BOOL)isActive {
    BOOL isActive = NO;
    
    if ([self.activation isEqualToString:ACTIVE_IF_GREATER_THAN]) {
        isActive = self.value > self.activationValue;
    }else if([self.activation isEqualToString:ACTIVE_IF_LESS_THAN]) {
        isActive = self.value < self.activationValue;
    }else if([self.activation isEqualToString:ACTIVE_IF_EQUALS_TO]){
        isActive = self.value == self.activationValue;
    }
    
    return isActive;
}

-(void)reset {
    self.value = self.initialValue;
}

-(double)percentage {
    if ([self isActive]) {
        return 1;
    }
    double progress = abs(self.value - self.initialValue);
    double total = abs(self.activationValue - self.initialValue);
    
    if (![self.activation isEqualToString:ACTIVE_IF_EQUALS_TO]) {
        total += 1;
    }
    
    return progress / total;
}

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:kName];
    [encoder encodeInt:_value forKey:kValue];
    [encoder encodeObject:_activation forKey:kActivation];
    [encoder encodeInt:_initialValue forKey:kInitialValue];
    [encoder encodeInt:_activationValue forKey:kActivationValue];
    [encoder encodeObject:_tags forKey:kTags];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _name = [decoder decodeObjectForKey:kName];
        _value = [decoder decodeIntForKey:kValue];
        _activation = [decoder decodeObjectForKey:kActivation];
        _initialValue = [decoder decodeIntForKey:kInitialValue];
        _activationValue = [decoder decodeIntForKey:kActivationValue];
        _tags = [decoder decodeObjectForKey:kTags];
    }
    return self;
}

@end
