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
    CharacterSprite *sprite;
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
    SpriteDirections direction;
    
    BattleController *controller;
    NSMutableArray *pointArray;
    SkillSet *skillSet;
    CGContextRef context;
}

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
