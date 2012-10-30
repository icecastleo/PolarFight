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
#import "BattleSprite.h"
@interface SkillSet : NSObject {
    NSString *name;
    RangeType *effectRange;
    BattleSprite* battleSprite;
}
-(id) initWithRange:(BattleSprite*) sprite range:(RangeType*) range;
-(NSMutableArray *) getEffectTargets:(NSMutableArray *)enemies;
-(void) showAttackRange:(BOOL)visible;
-(void) setRangeRotation:(float) offX:(float) offY;
@end
