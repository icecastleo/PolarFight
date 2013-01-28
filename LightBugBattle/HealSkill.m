//
//  HealSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "HealSkill.h"
#import "Character.h"

@implementation HealSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideAlly],@"rangeSides",@[kRangeFilterSelf],@"rangeFilters",kRangeTypeCircle,@"rangeType",@75,@"effectRadius",nil];
        
        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)execute {    
    int attack = [character getAttribute:kCharacterAttributeAttack].value;
    
    DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:attack / 3 damageType:kDamageTypeSkill damager:character];
    [character receiveDamageEvent:event];
    
    for (Character *target in [range getEffectTargets]) {
        [target getHeal:attack];
    }
}

@end
