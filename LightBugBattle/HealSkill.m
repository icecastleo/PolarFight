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

-(id)init {
    if (self = [super init]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideAlly],@"rangeSides",@[kRangeFilterSelf],@"rangeFilters",kRangeTypeCircle,@"rangeType",@50,@"radius",nil];

        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)execute {
    if (range.character == nil) {
        range.character = self.owner;
    }
    
    int attack = [self.owner getAttribute:kCharacterAttributeAttack].value;
    
    DamageEvent *event = [[DamageEvent alloc] initWithBaseDamage:attack / 2 damageType:kDamageTypeSkill damager:self.owner];
    [self.owner receiveDamageEvent:event];
    
    for (Character *target in [range getEffectTargets]) {
        [target getHeal:attack];
    }
}

@end
