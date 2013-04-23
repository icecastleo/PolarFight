//
//  AccumulateAttribute.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/13.
//
//

#import "AccumulateAttribute.h"

@implementation AccumulateAttribute

-(id)initWithType:(CharacterAttributeType)aType withQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c {
    if (self = [super initWithType:aType withQuadratic:a withLinear:b withConstantTerm:c]) {
        // Special modification by game
        if (aType < kCharacterAttributeUpdateBoundary) {
            linear = 0.02 * c;
        }
    }
    return self;
}

-(int)valueWithLevel:(int)level {
    return level * (level + 1) * (2*level + 1) / 6 * quadratic + (1 + level) * level / 2 * linear + constantTerm;
}

@end
