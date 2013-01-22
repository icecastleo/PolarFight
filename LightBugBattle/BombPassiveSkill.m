//
//  BombPassiveSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/11.
//
//

#import "BombPassiveSkill.h"
#import "Character.h"

@implementation BombPassiveSkill

-(void)characterWillRemoveDelegate:(Character *)sender {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:sender,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@150,@"effectRadius",nil];
    
    Range *range = [Range rangeWithParameters:dictionary];

    int damage = [sender getAttribute:kCharacterAttributeAttack].value * 5;
    
    for (Character *target in [range getEffectTargets]) {
        DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:damage damageType:kDamageTypeSkill damager:sender];
        [target receiveDamageEvent:event];
    }
}

@end
