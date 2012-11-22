//
//  AttributeModifier.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/16.
//
//

#import "AttributeModifier.h"

@implementation AttributeModifier

-(float)modifyValue:(float)value {
    [NSException raise:@"Called abstract method!" format:@"You should override it."];
    return value;
}

@end
