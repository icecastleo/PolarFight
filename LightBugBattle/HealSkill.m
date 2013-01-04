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
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],@"rangeSides",@[kRangeFilterSelf],@"rangeFilters",kRangeTypeCircle,@"rangeType",@50,@"radius",nil];

        range = [Range rangeWithParameters:dictionary onCharacter:aCharacter];
    }
    return self;
}

-(void)execute {    
    int attack = [character getAttribute:kCharacterAttributeAttack].value;
    
    DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:attack / 2 damageType:kDamageTypeSkill damager:character];
    [character receiveDamageEvent:event];
    
    for (Character *target in [range getEffectTargets]) {
        [target getHeal:attack];
    }
}

@end
