//
//  BattleSprite.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum {
    stateAttack,
    stateMove,
    stateIdle,
    stateDead
} SpriteStates;

typedef enum {
    directionUp,
    directionDown,
    directionLeft,
    directionRight
} SpriteDirections;

@interface BattleSprite : CCSprite {
    
    NSString *name;
    
//    int hp;
//    int attack;
//    int defense;
//    int speed;
//    
//    int moveSpeed;
//    int moveTime;
    
    CCAnimate *upAnimate;
    CCAnimate *downAnimate;
    CCAnimate *rightAnimate;
    CCAnimate *leftAnimate;
    
//    SpriteStates state;
    SpriteDirections direction;
}

@property int player;

@property int hp;
@property (readonly) int attack;
@property (readonly) int defense;
@property (readonly) int speed;
@property (readonly) int moveSpeed;
@property (readonly) int moveTime;

@property (readonly) SpriteStates state;

//+(id) spriteWithRandomAbility;
//-(id) initWithRandomAbility;

+(id) spriteWithFile:(NSString *)filename player:(int)player;
-(id) initWithFile:(NSString *)filename player:(int)player;

-(void) addPosition:(CGPoint)point time:(ccTime)delta;

-(void) attackEnemy:(NSMutableArray*) enemies;
-(void) getDamage:(int) damage;

-(void) end;
@end
