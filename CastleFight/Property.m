//
//  Property.m
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//


#import "Property.h"

#define kNameKey       @"name"
#define kValueKey      @"value"
#define kActivationKey       @"activation"
#define kInitialValueKey      @"initialValue"
#define kActivationValueKey       @"activationValue"
#define kTagsKey      @"tags"

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
        _name = [dic objectForKey:@"name"];
        _value = [[dic objectForKey:@"value"] intValue];
        _activation = [dic objectForKey:@"activation"];
        _initialValue = [[dic objectForKey:@"initialValue"] intValue];
        _activationValue = [[dic objectForKey:@"activationValue"] intValue];
        _tags = [dic objectForKey:@"tags"];
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

#pragma mark NSCoding

-(void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_name forKey:kNameKey];
    [encoder encodeInt:_value forKey:kValueKey];
    [encoder encodeObject:_activation forKey:kActivationKey];
    [encoder encodeInt:_initialValue forKey:kInitialValueKey];
    [encoder encodeInt:_activationValue forKey:kActivationValueKey];
    [encoder encodeObject:_tags forKey:kTagsKey];
}

-(id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        _name = [decoder decodeObjectForKey:kNameKey];
        _value = [decoder decodeIntForKey:kValueKey];
        _activation = [decoder decodeObjectForKey:kActivationKey];
        _initialValue = [decoder decodeIntForKey:kInitialValueKey];
        _activationValue = [decoder decodeIntForKey:kActivationValueKey];
        _tags = [decoder decodeObjectForKey:kTagsKey];
    }
    return self;
}

@end
