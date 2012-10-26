//
//  AttackType.h
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class BattleSprite;
typedef enum {
    effectSideEnemy,
    effectSideAlly,
    effectSideBoth
} EffectSides;

typedef enum {
     effectNumsSingleByDistance,
     effectNumsMulti
} EffectNums;

typedef enum{
    effectExceptSelf,
    effectSelf
}EffectSelfOrNot;

@interface AttackType : NSObject {
    NSString *name;
    NSMutableArray *attackPointArray;
    CGMutablePathRef attackRange;
    BattleSprite* battleSprite;
    EffectNums effectNums;
    EffectSides effectSides;
    EffectSelfOrNot effectSelfOrNot;
}

@property (nonatomic, retain) BattleSprite *battleSprite;
@property (nonatomic, retain) NSMutableArray *attackPointArray;
@property (nonatomic) CGMutablePathRef attackRange;
-(id) initWithSprite:(BattleSprite*) sprite;
-(NSMutableArray *) getEffectTargets:(NSMutableArray *)enemies;
-(void)setPath;
@end
