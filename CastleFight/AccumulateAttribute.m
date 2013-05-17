//
//  AccumulateAttribute.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/13.
//
//

#import "AccumulateAttribute.h"

@implementation AccumulateAttribute

//-(id)initWithQuadratic:(float)a withLinear:(float)b withConstantTerm:(float)c {
//    if (self = [super initWithQuadratic:a withLinear:b withConstantTerm:c]) {
//        // FIXME: special hack modification by game
//        linear = 0.02 * c;
//    }
//    return self;
//}

-(int)valueWithLevel:(int)level {
    return level * (level + 1) * (2*level + 1) / 6 * quadratic + (1 + level) * level / 2 * linear + constantTerm;
}

@end
