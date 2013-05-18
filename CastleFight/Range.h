//
//  AttackType.h
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Entity.h"

// RangeType
#define kRangeTypeCircle @"RangeCircle"
#define kRangeTypeFanShape @"RangeFanShape"
#define kRangeTypeLine @"RangeLine"
#define kRangeTypeProjectile @"ProjectileRange"

// TODO: Add target entities component!!

// RangeKey
#define kRangeKeyType @"Type"
#define kRangeKeySide @"Side"
#define kRangeKeyFilter @"Filter"
#define kRangeKeyTargetLimit @"TargetLimit"
#define kRangeKeySpriteFile @"SpriteFile"

#define kRangeKeyRadius @"Radius"
#define kRangeKeyAngle @"Angle"
#define kRangeKeyWidth @"Width"
#define kRangeKeyLength @"Length"
#define kRangeKeyDistance @"Distance"

#define kRangeKeyEffectRange @"EffectRange"

// Projectile Range
#define kRangeKeyIsPiercing @"IsPiercing"

// RangeSide
#define kRangeSideAlly @"Ally"
#define kRangeSideEnemy @"Enemy"

// RangeFilter
#define kRangeFilterSelf @"Self"

@interface Range : NSObject {
    NSString *name;
    
    NSArray *sides;
    NSArray *filters;
    
    int targetLimit;
    
    CGMutablePathRef attackRange;
    
    int width;
    int height;
}

@property Entity *owner;
@property (readonly) CCSprite *rangeSprite;
@property (readonly) CGPoint effectPosition;

+(id)rangeWithParameters:(NSMutableDictionary *)dict;
-(id)initWithParameters:(NSMutableDictionary *)dict;

-(void)setDirection:(CGPoint)velocity;
-(NSArray *)getEffectEntities;

@end
