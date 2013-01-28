//
//  BombSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/24.
//
//

#import "BombSkill.h"
#import "RangeShooter.h"
#import "Character.h"

@implementation BombSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {
        
    }
    return self;
}

-(void)execute {
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"Arrow.png",@"rangeSpriteFile",nil];
    
    RangeShooter *shooter = [[RangeShooter alloc] initWithRange:[Range rangeWithParameters:dictionary]];
    
    [shooter shoot:character.direction speed:10 delegate:self];
}

-(void)delayExecute:(NSArray *)targets {
    for(Character *target in targets) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        [target receiveAttackEvent:event];
    }
}

@end
