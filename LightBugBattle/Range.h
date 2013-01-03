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

@interface Range : NSObject {
    NSString *name;
    CGMutablePathRef attackRange;
    __weak Character* character;
    
//    RangeSide rangeSide;
//    EffectSelfOrNot effectSelfOrNot;
    
    NSArray *sides;
    NSArray *filters;
    
    CCSprite *rangeSprite;
    int rangeHeight;
    int rangeWidth;
}

@property (nonatomic, weak) Character *character;
@property (nonatomic, strong) CCSprite *rangeSprite;
@property (nonatomic) CGMutablePathRef attackRange;

+(id)rangeWithParameters:(NSMutableDictionary *)dict;
-(NSMutableArray *) getEffectTargets;
-(BOOL) containTarget:(Character *)temp;
-(void) setRotation:(float) offX:(float) offY;
-(void)setRangeSprite;
@end
