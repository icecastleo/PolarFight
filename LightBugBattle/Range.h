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
    
    int rangeHeight;
    int rangeWidth;
}
@property NSArray *sides;
@property NSArray *filters;

@property (readonly, weak) Character *character;
@property (readonly, strong) CCSprite *rangeSprite;

+(id)rangeWithParameters:(NSMutableDictionary *)dict onCharacter:(Character *)aCharacter;
-(NSMutableArray *)getEffectTargets;
-(BOOL)containTarget:(Character *)temp;
-(void)setDirection:(CGPoint)velocity;
-(void)setRangeSprite;
@end
