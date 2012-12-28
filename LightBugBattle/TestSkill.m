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
    
    //NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeCircle",@"rangeName",200,"@radius" nil];//Circle
    
   // NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeFanShape",@"rangeName",@200,@"effectRadius",@(M_PI/2),@"effectAngle",nil];    //FanShape
    //NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeLine",@"rangeName",@700,@"effectDistance",@40,@"effectWidth",nil];//Line
     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeFarCircle",@"rangeName",@120,@"effectDistance",@40,@"effectRadius",nil];//FarCircle
    
    id range =  [RangeType initWithParameters:dict];

    return [self initWithCharacter:aCharacter rangeType:range];
}

-(id) initWithCharacter:(Character*)aCharacter rangeType:(Range*)range {
    if( (self=[super init]) ) {    
        character = aCharacter;
        [range setCharacter:character];
        [range showPoints];
        effectRange = range;
        effectSet = [[NSMutableArray alloc] init];
        [effectSet addObject:[[AttackEffect alloc] initWithAttackType:kAttackNoraml]];
//        [effectSet addObject:[TimeStatusEffect statusWithType:statusPoison withTime:3]];
    }
    
    return self;
}

-(void) execute {
    NSMutableArray *effectTargets= [effectRange getEffectTargets];
    for (Character* target in effectTargets) {
        for (Effect *effectItem in effectSet) {
            [effectItem doEffectFromCharacter:character toCharacter:target];
        }
    }
}

-(void) showAttackRange:(BOOL)visible {
    effectRange.rangeSprite.visible = visible;
}

-(void) setRangeRotation:(float)offX :(float)offY {
    [effectRange setRotation:offX :offY];
}

@end
