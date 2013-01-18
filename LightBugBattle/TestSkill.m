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
@implementation TestSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@500,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
        
        range = [Range rangeWithParameters:dictionary onCharacter:aCharacter];
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
    RangeCarrier* rc = [[RangeCarrier alloc] init:range iconFileName:@"Arrow.png"];
    
    [rc shoot:character.direction speed:10 delegate:self];
}

-(void)delayExecute:(NSMutableArray *)targets carrier:(RangeCarrier *)carrier {
    for(Character *target in targets) {
//        NSLog(@"%@ is under attack",target.name);
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        [target receiveAttackEvent:event];
    }
}
@end
