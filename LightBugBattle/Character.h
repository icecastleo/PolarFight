//
//  BattleCharacter.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@class SkillSet;
@class BattleController;
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

@interface Character : NSObject {
    NSString *name;
    
    CCSprite *characterSprite;
    CCSprite *bloodSprite;
    
    int maxHp;
    
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
    
    BattleController *controller;
    NSMutableArray *pointArray;
    SkillSet *skillSet;
    CGContextRef context;
}

@property int player;

@property (readonly) int hp;
@property (readonly) int attack;
@property (readonly) int defense;
@property (readonly) int speed;
@property (readonly) int moveSpeed;
@property (readonly) int moveTime;

@property (readonly) SpriteStates state;

@property (readonly) CCSprite *characterSprite;
@property CGPoint position;

@property (nonatomic, retain) NSMutableArray *pointArray;

+(id) characterWithController:(BattleController *) battleController player:(int)pNumber withFile:(NSString *) filename;
-(id) initWithController:(BattleController *) battleController player:(int)pNumber withFile:(NSString *) filename;

-(void) addPosition:(CGPoint)velocity time:(ccTime)delta;

-(void) attackEnemy:(NSMutableArray*) enemies;
-(void) getDamage:(int) damage;
-(void) showAttackRange:(BOOL)visible;
-(void) end;
-(void) setAttackRotation:(float) offX:(float) offY;

-(void) setPosition:(CGPoint)position;
-(CGPoint) position;

@end
