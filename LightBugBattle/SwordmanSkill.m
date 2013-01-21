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
//        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"Arrow.png",@"rangeSpriteFile",character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@500,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@500,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
        
        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)execute {
    for (Character *target in [range getEffectTargets]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        event.knockOutPower = 4;
        event.knouckOutCollision = YES;
        [target receiveAttackEvent:event];
    }
}

@end
