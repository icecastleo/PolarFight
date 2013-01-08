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
    
    NSArray *sides;
    NSArray *filters;

    int rangeHeight;
    int rangeWidth;
}

@property (readonly, weak) Character *character;
@property (readonly, strong) CCSprite *rangeSprite;

+(id)rangeWithParameters:(NSMutableDictionary *)dict onCharacter:(Character *)aCharacter;
-(NSMutableArray *) getEffectTargets;
-(BOOL)containTarget:(Character *)temp;
-(void)setRotation:(float)offX :(float)offY;
-(void)setRangeSprite;
@end
