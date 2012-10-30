//
//  SkillSet.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SkillSet.h"


@implementation SkillSet

-(id) initWithRangeName:(BattleSprite *)sprite rangeName:(NSString *)rangeName
{
    id range = [[NSClassFromString(rangeName) alloc]  initWithSprite:sprite];
    return [self initWithRange:sprite range:range];
}

-(id) initWithRange:(BattleSprite*) sprite range:(RangeType*) range
{
    if( (self=[super init]) ) {
        
        battleSprite=sprite;
//        effectRange=range;
        effectRange = [[RangeFanShape alloc] initWithSprite:sprite];
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
