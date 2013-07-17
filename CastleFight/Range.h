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
#import "PhysicsSystem.h"

CLS_DEF(b2Body);

// RangeType
#define kRangeTypeCircle @"RangeCircle"
#define kRangeTypeFanShape @"RangeFanShape"
#define kRangeTypeLine @"RangeLine"
#define kRangeTypeProjectile @"ProjectileRange"
#define kRangeTypeSimpleXY @"RangeSimpleXY"

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

// Projectile Range
#define kRangeKeyIsPiercing @"IsPiercing"
#define kRangeKeyEffectRange @"EffectRange"

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
    
    PhysicsSystem *physicsSystem;
    b2Body *body;
    
    // Range's distance from entity
    int distance;
    
//    CGMutablePathRef attackRange;
//    
//    int width;
//    int height;
}

@property (nonatomic) Entity *owner;
//@property (readonly) CCSprite *rangeSprite;
@property (readonly) CGPoint effectPosition;

+(id)rangeWithParameters:(NSMutableDictionary *)dict;
-(id)initWithParameters:(NSMutableDictionary *)dict;
-(BOOL)checkSide:(Entity *)entity;
-(BOOL)checkFilter:(Entity *)entity;
-(NSArray *)sortEntities:(NSArray *)entities;
//-(void)setDirection:(CGPoint)velocity;
-(NSArray *)getEffectEntities;
-(BOOL)containEntity:(Entity *)entity;

@end
