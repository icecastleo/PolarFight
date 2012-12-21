//
//  ReflecAttackDamage.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/19.
//
//

#import "ReflectAttackDamage.h"

@implementation ReflectAttackDamage

-(id)initWithProbability:(int)aProbability damagePercent:(int)aPercent {
    if(self = [super init]) {
        probability = aProbability;
        percent = aPercent;
    }
    return self;
}

@end
