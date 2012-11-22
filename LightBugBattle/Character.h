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
    
//    NSMutableDictionary *timeStatusDictionary;
//    NSMutableDictionary *auraStatusDictionary;
}
@property (assign) BattleController *controller;

@property (nonatomic, assign) int player;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picFilename;
@property (nonatomic, assign) int maxHp;

@property (readonly) int hp;
@property (readonly) int attack;
@property int attackBonus;
@property float attackMultiplier;
@property (readonly) int defense;
@property (readonly) int speed;
@property (readonly) int moveSpeed;
@property (readonly) int moveTime;

@property (nonatomic, assign) int level;
@property (nonatomic, assign) CharacterType roleType;
@property (nonatomic, assign) int tag;

@property (readonly) NSMutableDictionary* timeStatusDictionary;
@property (readonly) NSMutableDictionary *auraStatusDictionary;
@property (readonly) CharacterSprite *sprite;

@property (readonly) SpriteStates state;
@property (readonly) SpriteDirections direction;

@property CGPoint position;

@property (nonatomic, retain) NSMutableArray *pointArray;

+(id) characterWithFileName:(NSString *) filename player:(int)pNumber;
-(id) initWithFileName:(NSString *) filename player:(int)pNumber;

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

- (id)initWithName:(NSString *)rname fileName:(NSString *)rfilename;

@end
