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
//#define kRangeTypeFanShape @"RangeFanShape"
#define kRangeTypeSquare @"SquareRange"
//#define kRangeTypeSimpleXY @"RangeSimpleXY"

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
#define kRangeKeyHeight @"Height"
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
    int width;
    
    NSArray *sides;
    NSArray *filters;
    
    int targetLimit;
    
    PhysicsSystem *physicsSystem;
    b2Body *body;
    
    // Range's distance from entity
    int distance;
}

@property (readonly) int width;
@property (nonatomic) Entity *owner;
@property (readonly) CGPoint effectPosition;

+(id)rangeWithParameters:(NSMutableDictionary *)dict;
-(id)initWithParameters:(NSMutableDictionary *)dict;
-(BOOL)checkFilter:(Entity *)entity;
-(NSArray *)sortEntities:(NSArray *)entities;

-(NSArray *)getEffectEntities;
-(BOOL)containEntity:(Entity *)entity;

@end
