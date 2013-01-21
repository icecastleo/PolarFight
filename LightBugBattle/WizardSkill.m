//
//  WizardSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "WizardSkill.h"
#import "Character.h"

@implementation WizardSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeFarCircle,@"rangeType",@50,@"effectRadius",@100,@"effectDistance",nil];
        
        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)execute {
    for (Character *target in [range getEffectTargets]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        [target receiveAttackEvent:event];
    }
}

@end
