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

-(void)setValue:(int)value {    
    _value = MIN(father.value, value);
    _value = MAX(0, _value);
}

@end
