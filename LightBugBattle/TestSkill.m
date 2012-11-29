//
//  Skill.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestSkill.h"
#import "Character.h"
#import "TimeStatusEffect.h"

@implementation TestSkill

-(id) initWithRangeName:(Character*)aCharacter rangeName:(NSString*)rangeName {
    
    id range = [[NSClassFromString(rangeName) alloc] initWithCharacter:aCharacter];
    return [self initWithRange:aCharacter range:range];
}

-(id) initWithRange:(Character*)aCharacter range:(RangeType*) range {
    if( (self=[super init]) ) {    
        character = aCharacter;
//        effectRange = range;
        effectRange = [[RangeFanShape alloc] initWithCharacter:character];
        effectSet = [[NSMutableArray alloc] init];
//        [effectSet addObject:[[EffectDamage alloc] init]];
        [effectSet addObject:[TimeStatusEffect statusWithType:statusPoison withTime:3]];
    }
    
    return self;
}

-(void) doSkill:(NSMutableArray*)targets
{
    NSMutableArray *effectTargets= [self getEffectTargets:targets];
    for (Character* target in effectTargets) {
        for (Effect *effectItem in effectSet) {
            [effectItem doEffect:target];
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
