//
//  SwordmanSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "SwordmanSkill.h"
#import "Character.h"

@implementation SwordmanSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@200,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
        
        range = [Range rangeWithParameters:dictionary onCharacter:aCharacter];
    }
    return self;
}

-(void)execute {
    
    int attack = [character getAttribute:kCharacterAttributeAttack].value;
    
    for (Character *target in [range getEffectTargets]) {
        DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:attack damageType:kDamageTypeAttack damager:character];
        [target receiveDamageEvent:event];
    }
}

@end
