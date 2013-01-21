//
//  TestSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/14.
//
//

#import "TestSkill.h"
#import "AttackEvent.h"
#import "Character.h"
#import "RangeCarrier.h"
#import "RangeShooter.h"
@implementation TestSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {

//        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@500,@"effectRadius",@(M_PI/2),@"effectAngle",nil];

//        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",nil];
        
//        range = [Range rangeWithParameters:dictionary];
    }
    return self;
}

-(void)execute {
    //    for (Character *target in [range getEffectTargets]) {
    //        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
    ////        event.knockOutPower = 4;
    ////        event.knouckOutCollision = YES;
    //        [target receiveAttackEvent:event];
    //    }
//    RangeCarrier* rc = [[RangeCarrier alloc] init:range iconFileName:@"Arrow.png"];
    
//    [rc shoot:character.direction speed:10 delegate:self];
    
    NSMutableDictionary *effectDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@50,@"effectRadius",nil];
    
    Range *effectRange = [Range rangeWithParameters:effectDictionary];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@"Arrow.png",@"rangeSpriteFile",effectRange,@"rangeEffectRange",nil];
    
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
