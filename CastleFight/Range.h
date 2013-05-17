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

@interface Range : NSObject {
    NSString *name;
    
    CGMutablePathRef attackRange;
    
    int width;
    int height;

    Range *effectRange;
    
    int targetLimit;
}

@property NSArray *sides;
@property NSArray *filters;

@property (weak, nonatomic) Entity *owner;
@property (readonly) CCSprite *rangeSprite;
@property (readonly) CGPoint effectPosition;

+(id)rangeWithParameters:(NSMutableDictionary *)dict;
-(id)initWithParameters:(NSMutableDictionary *)dict;

-(NSArray *)getEffectEntities;
-(void)setDirection:(CGPoint)velocity;

@end
