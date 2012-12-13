//
//  MultiplyModifier.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/16.
//
//

#import "MultiplyModifier.h"

@implementation MultiplyModifier

+(id)modifierWithValue:(float)value {
    return [[self alloc] initWithValue:value];
}

-(id)initWithValue:(float)value {
    if(self = [super init]) {
        mutiplier = value;
    }
    return self;
}

-(float)modifyValue:(float)value {
    return value * mutiplier;
}

@end
