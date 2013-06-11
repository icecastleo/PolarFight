//
//  ReflecAttackDamage.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/19.
//
//

#import "ReflectAttackDamageSkill.h"
#import "DefenderComponent.h"
#import "DamageEvent.h"
#import "Damage.h"

@implementation ReflectAttackDamageSkill

-(id)initWithProbability:(int)aProbability reflectPercent:(int)aPercent {
    if(self = [super init]) {
        probability = aProbability;
        percent = aPercent;
    }
    return self;
}


-(void)checkEvent:(EventType)eventType  Message:(id)message {
    
    if (eventType != kEventReceiveDamage) {
        return;
    }
    
    Damage *damage;
    if ([message isKindOfClass:[Damage class]]) {
        damage = (Damage*)message;
    }else {
        return;
    }
    
    if (damage.source != kDamageSourceMelee) {
        return;
    }
    
    if (probability < (arc4random() % 100)) {
        return;
    }
    
    [self activeEffect:damage];
}

-(void)activeEffect:(Damage *)damage {
    
    DamageEvent *counterEvent = [[DamageEvent alloc] initWithSender:self.owner damage:damage.damage*percent/100 damageType:kDamageTypeNormal damageSource:kDamageSourcePassiveSkill receiver:damage.sender];
    
    DefenderComponent *defender = (DefenderComponent *)[damage.sender getComponentOfClass:[DefenderComponent class]];
    
    [defender.damageEventQueue addObject:counterEvent];
}

@end
