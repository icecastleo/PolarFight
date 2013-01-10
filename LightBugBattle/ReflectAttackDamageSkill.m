//
//  ReflecAttackDamage.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/19.
//
//

#import "ReflectAttackDamageSkill.h"
#import "Character.h"

@implementation ReflectAttackDamageSkill

-(id)initWithProbability:(int)aProbability reflectPercent:(int)aPercent {
    if(self = [super init]) {
        probability = aProbability;
        percent = aPercent;
    }
    return self;
}

-(void)character:(Character *)sender didReceiveDamage:(Damage *)damage {
    if (damage.type != kDamageTypeAttack) {
        return;
    }
    
    int random = arc4random_uniform(100) + 1;
    
    if (probability >= random) {
        DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:damage.value * percent / 100 damageType:kDamageTypePassiveSkill damager:sender];
        
        [damage.damager receiveDamageEvent:event];
    }
}

@end
