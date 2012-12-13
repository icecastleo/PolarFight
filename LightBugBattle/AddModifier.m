//
//  AddModifier.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/16.
//
//

#import "AddModifier.h"

@implementation AddModifier

+(id)modifierWithValue:(float)value {
    return [[self alloc] initWithValue:value];
}

-(id)initWithValue:(float)value {
    if(self = [super init]) {
        add = value;
    }
    return self;
}

-(float)modifyValue:(float)value {
    return value + add;
}

@end
