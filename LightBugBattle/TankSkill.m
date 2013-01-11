//
//  TankSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/10.
//
//

#import "TankSkill.h"
#import "Character.h"
#import "BattleController.h"

@implementation TankSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@100,@"effectRadius",nil];
        
        range = [Range rangeWithParameters:dictionary onCharacter:aCharacter];
    }
    return self;
}

-(void)execute {
    for (Character *target in [range getEffectTargets]) {
        [[BattleController currentInstance] knockOut:target velocity:ccpSub(character.position, target.position) power:2];
//        [character attackCharacter:target withAttackType:kAttackNoraml];
    }
}

@end