//
//  SkillSet.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SkillSet.h"
#import "Character.h"

@implementation SkillSet

-(id) initWithRangeName:(Character *)battleCharacter rangeName:(NSString *)rangeName {
    
    id range = [[NSClassFromString(rangeName) alloc] initWithCharacter:battleCharacter];
    return [self initWithRange:battleCharacter range:range];
}

-(id) initWithRange:(Character*)battleCharacter range:(RangeType*) range {
    if( (self=[super init]) ) {    
        character = battleCharacter;
//        effectRange=range;
        effectRange = [[RangeFanShape alloc] initWithCharacter:character];
        effectSet = [[NSMutableArray alloc] init];
        [effectSet addObject:[[EffectDamage alloc] init]];
    }
    
    return self;
}

-(void) doSkill:(NSMutableArray *)targets
{
    NSMutableArray *effectTargets= [self getEffectTargets:targets];
    for (BattleSprite *sprite in effectTargets) {
        for (EffectType *effectItem in effectSet) {
            [effectItem doEffect:sprite];
        }
    }
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
