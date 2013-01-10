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

-(void)execute {
    int damage = [character getAttribute:kCharacterAttributeHp].value;
    
    DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:damage damageType:kDamageTypeSkill damager:character];
    
    [character receiveDamageEvent:event];
}

@end
