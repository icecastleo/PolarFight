//
//  BattleCharacter.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Constant.h"
#import "CharacterSprite.h"
#import "SkillKit.h"

@class BattleController;

@interface Character : NSObject {
    //    BattleController *controller;
//    CharacterSprite *sprite;
    //    NSString *name;
    //    int maxHp;
    
    //    int hp;
    //    int attack;
    //    int defense;
    //    int speed;
    //
    //    int moveSpeed;
    //    int moveTime;
    
    //    SpriteStates state;
//    SpriteDirections direction;
    
    NSMutableArray *pointArray;
    SkillSet *skillSet;
    CGContextRef context;
    
    NSMutableDictionary *statusDictionary;
}
@property (assign) BattleController *controller;

@property int player;
@property (readonly) NSString *name;
@property (readonly) int maxHp;

@property (readonly) int hp;
@property (readonly) int attack;
@property (readonly) int defense;
@property (readonly) int speed;
@property (readonly) int moveSpeed;
@property (readonly) int moveTime;

@property (readonly) SpriteStates state;

@property (readonly) CharacterSprite *sprite;
@property (readonly) SpriteDirections direction;
@property CGPoint position;

@property (nonatomic, retain) NSMutableArray *pointArray;

-(id) initWithFileName:(NSString *) filename player:(int)pNumber;

-(void) addPosition:(CGPoint)velocity time:(ccTime)delta;

-(void) attackEnemy:(NSMutableArray*) enemies;
-(void) getDamage:(int) damage;
-(void) showAttackRange:(BOOL)visible;
-(void) end;
-(void) setAttackRotation:(float) offX:(float) offY;

-(void) setPosition:(CGPoint)position;
-(CGPoint) position;

-(void) addStatus:(StatusType)type withTime:(int)time;
-(void) removeStatus:(StatusType)type;

@end
