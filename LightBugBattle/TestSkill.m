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
    
    [rc shoot:character.directionVelocity speed:50 delegate:self];
    
}


-(void)delayExecute:(NSMutableArray *) target carrier:(RangeCarrier*) carrier {
    
    for(Character *item in target)
    {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:item];
        [item receiveAttackEvent:event];
        NSLog(@"%@ is under attack",item.name);
    }
}
@end
