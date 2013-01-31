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
        [ranges addObject:range];
        
        NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@150,@"effectRadius",nil];
        
        Range *range2 = [Range rangeWithCharacter:aCharacter parameters:dictionary2];
        
        [ranges addObject:range2];
    }
    return self;
}

-(void)execute {

    for (Character *target in [range getEffectTargets]) {
        AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
        event.knockOutPower = 25;
        event.knouckOutCollision = YES;
        [target receiveAttackEvent:event];
    }
    
    count++;
    count %= 3;
    
    range.rangeSprite.visible = NO;
    range = ranges[count];
    range.rangeSprite.visible = YES;
}

-(CCAnimate *)createAnimateWithName:(NSString*)name frameNumber:(int)anInteger {
    CCSpriteFrameCache* frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    // Load the animation frames
    NSMutableArray* frames = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 1; i <= anInteger; i++)
    {
        NSString* file = [NSString stringWithFormat:@"%@%03d.png",name, i];
        CCSpriteFrame* frame = [frameCache spriteFrameByName:file];
        [frames addObject:frame];
    }
    // Create an animation object from all the sprite animation frames
    CCAnimation* animation = [CCAnimation animationWithSpriteFrames:frames delay:0.1f];
    animation.restoreOriginalFrame = YES;
    CCAnimate* animate = [CCAnimate actionWithAnimation:animation];
    
    return animate;
}


@end
