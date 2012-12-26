//
//  AttackType.h
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class Character;
typedef enum {
    effectSideEnemy,
    effectSideAlly,
    effectSideBoth
} EffectSides;

typedef enum{
    effectExceptSelf,
    effectSelf
}EffectSelfOrNot;

@interface RangeType : NSObject {
    NSString *name;
    CGMutablePathRef attackRange;
    __weak Character* character;
    EffectSides effectSides;
    EffectSelfOrNot effectSelfOrNot;
    CCSprite *rangeSprite;
    int rangeHeight;
    int rangeWidth;
}

@property (nonatomic, weak) Character *character;
@property (nonatomic, strong) CCSprite *rangeSprite;
@property (nonatomic) CGMutablePathRef attackRange;

+(id)initWithParameters:(NSMutableDictionary*) dict;
-(id) initWithCharacter:(Character*) aCharacter;
-(NSMutableArray *) getEffectTargets:(NSMutableArray *)enemies;
-(BOOL) containTarget:(Character *)temp;
-(void) setRotation:(float) offX:(float) offY;
-(void)showPoints;
@end
