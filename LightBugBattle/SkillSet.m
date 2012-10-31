//
//  SkillSet.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SkillSet.h"


@implementation SkillSet

-(id) initWithRange:(Character*)battleCharacter range:(RangeType*) range
{
    if( (self=[super init]) ) {
        
        character = battleCharacter;
//        effectRange=range;
//        effectRange = [[RangeFanShape alloc] initWithSprite:character.characterSprite];
    }
    
    return self;
}

-(NSMutableArray *) getEffectTargets:(NSMutableArray *)enemies
{
    return [effectRange getEffectTargets:enemies];
}
-(void) showAttackRange:(BOOL)visible
{
    effectRange.rangeSprite.visible = visible;
}

-(void) setRangeRotation:(float) offX:(float) offY
{
    [effectRange setRotation:offX :offY];
}

@end
