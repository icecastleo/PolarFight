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

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@200,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
        
        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)execute {
    if (range.character == nil) {
        range.character = self.owner;
    }
    
    int attack = [self.owner getAttribute:kCharacterAttributeAttack].value;
    
    for (Character *target in [range getEffectTargets]) {
        DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:attack damageType:kDamageTypeAttack damager:self.owner];
        [target receiveDamageEvent:event];
    }
}

@end
