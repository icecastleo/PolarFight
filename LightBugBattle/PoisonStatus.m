//
//  PoisonStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "PoisonStatus.h"

@implementation PoisonStatus

-(id)initWithTime:(int)t toCharacter:(Character*)cha{
    if(self = [super initWithType:statusPoison withTime:t toCharacter:cha]) {
        [modifierMap addAttributeModifier:[AddModifier modifierWithValue:-30] toAttribute:attributeAttackBonus onCondition:ConditionMonsterAttack];
    }
    return self;
}

-(void)addEffec {
    character.attackBonus -= 50;
}

-(void)removeEffect {
    character.attackBonus += 50;
}

-(void)update {
    [character getDamage:character.maxHp / 5];
    [super update];
}

@end
