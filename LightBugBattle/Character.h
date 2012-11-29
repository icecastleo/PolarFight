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
    TestSkill *skill;
    CGContextRef context;
    
//    NSMutableDictionary *timeStatusDictionary;
//    NSMutableDictionary *auraStatusDictionary;
}
@property (unsafe_unretained) BattleController *controller;

@property (nonatomic) int player;
@property (unsafe_unretained, readonly) NSString *name;
@property (unsafe_unretained, readonly) NSString *picFilename;
@property (readonly) int maxHp;

@property (readonly) int hp;
@property (readonly) int attack;
@property int attackBonus;
@property float attackMultiplier;
@property (readonly) int defense;
@property (readonly) int speed;
@property (readonly) int moveSpeed;
@property (readonly) int moveTime;

@property (readonly) int level;
@property (readonly) CharacterType roleType;

@property (readonly) NSMutableDictionary* timeStatusDictionary;
@property (readonly) NSMutableDictionary *auraStatusDictionary;
@property (readonly) CharacterSprite *sprite;

@property (readonly) SpriteStates state;
@property (readonly) SpriteDirections direction;

@property CGPoint position;

@property (nonatomic, strong) NSMutableArray *pointArray;

- (id)initWithName:(NSString *)aName fileName:(NSString *)aFilename;

//-(void) addPosition:(CGPoint)velocity time:(ccTime)delta;
-(void) setCharacterWithVelocity:(CGPoint)velocity;

-(void) attackEnemy:(NSMutableArray*) enemies;
-(void) getDamage:(int) damage;
-(void) showAttackRange:(BOOL)visible;
-(void) end;

-(void) setPosition:(CGPoint)position;
-(CGPoint) position;

-(void) addTimeStatus:(TimeStatusType)type withTime:(int)time;
//-(void) addAuraStatus:(StatusType)type;
-(void)removeTimeStatus:(TimeStatusType)type;

@end
