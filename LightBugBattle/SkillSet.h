//
//  SkillSet.h
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "RangeType.h"

@class  Character;
@interface SkillSet : NSObject {
    NSString *name;
    RangeType *effectRange;
    Character* character;
    NSMutableArray* effectSet;
}
-(id) initWithRangeName:(Character*)battleCharacter rangeName:(NSString*) rangeName;
-(id) initWithRange:(Character*)battleCharacter range:(RangeType*) range;
-(NSMutableArray *) getEffectTargets:(NSMutableArray *)enemies;
-(void) showAttackRange:(BOOL)visible;
-(void) setRangeRotation:(float) offX:(float) offY;
-(void) doSkill:(NSMutableArray *)targets;
@end
