//
//  ProbabilityEffect.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/15.
//
//

#import "ProbabilityEffect.h"

@implementation ProbabilityEffect

+(id)effectWithEffect:(Effect *)effect probability:(int)prob {
    return [[self alloc]initWithEffect:effect probability:prob];
}

-(id)initWithEffect:(Effect *)effect probability:(int)prob {
    if(self = [super init]) {
        base = effect;
        probability = prob;
    }
    return self;
}

-(void)doEffect:(Character *)character {
    if(arc4random() % 100 + 1 > probability) {
        [base doEffect:character];
    }
}

@end
