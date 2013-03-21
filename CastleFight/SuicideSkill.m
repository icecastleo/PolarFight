//
//  SuicideSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/11.
//
//

#import "SuicideSkill.h"
#import "Character.h"
#import "DamageEvent.h"

@implementation SuicideSkill

-(void)setRanges {
    
}

-(void)activeSkill:(int)count {
    int damage = [character getAttribute:kCharacterAttributeHp].value;
    
    DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:damage damageType:kDamageTypeNormal damageSource:kDamageSourceMelee damager:character];
    
    [character receiveDamageEvent:event];
}

@end
