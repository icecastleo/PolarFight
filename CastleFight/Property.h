//
//  Property.h
//  CastleFight
//
//  Created by  浩翔 on 13/3/28.
//
//

#import <Foundation/Foundation.h>
#import "PlistDictionaryInitialing.h"

@interface Property : NSObject <NSCoding, PlistDictionaryInitialing>

@property int value;

@property (readonly) NSString *name;
@property (readonly) NSString *activation;
@property (readonly) NSArray *tags;
@property (readonly) double percentage;

-(id)initWithPropertyName:(NSString *)name InitialValue:(int)initialValue theActivationMode:(NSString *)activation ActivationValue:(int)activationValue tags:(NSArray *)tags;

-(id)initWithDictionary:(NSDictionary *)dic;

-(BOOL)isActive;
-(void)reset;

@end
