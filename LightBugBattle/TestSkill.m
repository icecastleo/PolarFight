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

//-(id)initWithCharacter:(Character*)aCharacter rangeName:(NSString*)rangeName {
//    
//    // NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeCircle",@"rangeName",200,"@radius" nil];//Circle
//    
//    // NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeFanShape",@"rangeName",@200,@"effectRadius",@(M_PI/2),@"effectAngle",nil];    //FanShape
//    // NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@0,@"effectSides",@0,@"effectSelfOrNot",@"RangeLine",@"rangeName",@700,@"effectDistance",@40,@"effectWidth",nil];//Line
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy,kRangeSideAlly],@"rangeSides",kRangeTypeCircle,@"rangeType",@120,@"effectDistance",@40,@"effectRadius",nil]; // FarCircle
//    
//    Range *range =  [Range rangeWithParameters:dict onCharacter:aCharacter];
//
//    return [self initWithCharacter:aCharacter rangeType:range];
//}

//-(id)initWithCharacter:(Character*)aCharacter rangeType:(Range*)range {
//    if( (self=[super init]) ) {    
//        character = aCharacter;
//        
//        effectRange = range;
//        effectSet = [[NSMutableArray alloc] init];
//        [effectSet addObject:[[AttackEffect alloc] initWithAttackType:kAttackNoraml]];
//    }
//    return self;
//}

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy,kRangeSideAlly],@"rangeSides",kRangeTypeFarCircle,@"rangeType",@120,@"effectDistance",@40,@"effectRadius",nil]; // FarCircle
        
        range = [Range rangeWithParameters:dict onCharacter:aCharacter];
    }
    return self;
}

-(void)execute {
//    NSMutableArray *effectTargets = [effectRange getEffectTargets];
//    for (Character *target in effectTargets) {
//        for (Effect *effectItem in effectSet) {
//            [effectItem doEffectFromCharacter:character toCharacter:target];
//        }
//    }
    for (Character *target in [range getEffectTargets]) {
//        [character attackCharacter:target withAttackType:kAttackNoraml];
    }
}

@end
