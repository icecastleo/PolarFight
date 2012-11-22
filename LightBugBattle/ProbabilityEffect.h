//
//  ProbabilityEffect.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/15.
//
//

#import "Effect.h"

@interface ProbabilityEffect : Effect {
    Effect *base;
    // Should be a number between 0 % 100
    int probability;
}

+(id)effectWithEffect:(Effect*)effect probability:(int)prob;
-(id)initWithEffect:(Effect*)effect probability:(int)prob;

@end
