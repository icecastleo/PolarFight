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
#import "AttackEffect.h"

@implementation TestSkill

-(id) initWithCharacter:(Character*)aCharacter rangeName:(NSString*)rangeName {
    
    id range = [[NSClassFromString(rangeName) alloc] initWithCharacter:aCharacter];
    return [self initWithCharacter:aCharacter rangeType:range];
}

-(id) initWithCharacter:(Character*)aCharacter rangeType:(RangeType*) range {
    if( (self=[super init]) ) {    
        character = aCharacter;
//        effectRange = range;
        effectRange = [range initWithCharacter:character];
        effectSet = [[NSMutableArray alloc] init];
        [effectSet addObject:[[AttackEffect alloc] initWithAttackType:kAttackNoraml]];
//        [effectSet addObject:[TimeStatusEffect statusWithType:statusPoison withTime:3]];
    }
    
    return self;
}

-(void) doSkill:(NSMutableArray*)targets
{
    NSMutableArray *effectTargets= [self getEffectTargets:targets];
    for (Character* target in effectTargets) {
        for (Effect *effectItem in effectSet) {
            [effectItem doEffectFromCharacter:character toCharacter:target];
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
