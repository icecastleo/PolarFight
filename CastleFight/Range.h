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
    
    int rangeHeight;
    int rangeWidth;
    
    Range *effectRange;
}
@property NSArray *sides;
@property NSArray *filters;

@property (readonly, weak) Character *character;
@property (readonly) CCSprite *rangeSprite;
@property (readonly) CGPoint effectPosition;

+(id)rangeWithCharacter:(Character *)aCharacter parameters:(NSMutableDictionary*)dict;
-(NSArray *)getEffectTargets;
-(void)setDirection:(CGPoint)velocity;

@end
