//
//  AttributeFactory.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/13.
//
//

#import "AttributeFactory.h"
#import "DependentAttribute.h"

@implementation AttributeFactory

+(Attribute *)createAttributeWithType:(CharacterAttribute)type withQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c {
    if (type < kCharacterAttributeBoundary) {
        Attribute *result = [[Attribute alloc] initWithQuadratic:a withLinear:b withConstantTerm:c];
        
        result.dependent = [[DependentAttribute alloc] initWithAttribute:result];
        
        return result;
        
    } else {
        return [[Attribute alloc] initWithQuadratic:a withLinear:b withConstantTerm:c];
    }
}

@end
