//
//  SwordmanSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/4.
//
//

#import "SwordmanSkill.h"
#import "Character.h"
#import "CCMoveCharacterBy.h"

@implementation SwordmanSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {

        ranges = [[NSMutableArray alloc] init];
        
//        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"tree01.gif",@"rangeSpriteFile",@[kRangeSideEnemy],@"rangeSides",kRangeTypeSprite,@"rangeType",@50,@"effectRadius",@(M_PI/2),@"effectAngle",nil];

        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:character,@"rangeCharacter",@[kRangeSideEnemy],@"rangeSides",kRangeTypeFanShape,@"rangeType",@75,@"effectRadius",@(M_PI/2),@"effectAngle",nil];
        
        range = [Range rangeWithCharacter:aCharacter parameters:dictionary];
        
        [ranges addObject:range];
        
        NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@150,@"effectRadius",nil];
        
        Range *range2 = [Range rangeWithCharacter:aCharacter parameters:dictionary2];
        
        [ranges addObject:range2];
        
        [ranges addObject:range];
        
        doing = NO;
        hasNext = NO;
        count = 0;
    }
    return self;
}

-(void)execute {
    if (!doing) {
        [self runSkill];
    }else {
        if (count == [character.sprite getCurrentAnimation]) {
            count++;
            hasNext = YES;
        }
        
        if (count >= ranges.count) {
            count = 0;
            hasNext = NO;
        }
    }
    
}

-(BOOL)hasNext {
    doing = NO;
    if (!hasNext) {
        count = 0;
        range.rangeSprite.visible = NO;
        range = ranges[count];
        range.rangeSprite.visible = YES;
    }
    return hasNext;
}

-(void)runSkill {
    range.rangeSprite.visible = NO;
    range = ranges[count];
    range.rangeSprite.visible = YES;
    hasNext = NO;
    doing = YES;
    [character.sprite runAttackAnimateFromSkill:count];
    for (Character *target in [range getEffectTargets]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        event.knockOutPower = 25;
        event.knouckOutCollision = YES;
        [target receiveAttackEvent:event];
    }
}

@end
