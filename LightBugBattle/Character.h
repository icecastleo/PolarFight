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

@property (nonatomic, assign) int player;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *picFilename;
@property (nonatomic, assign) int maxHp;

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int attack;
@property (nonatomic, assign) int defense;
@property (nonatomic, assign) int speed;
@property (nonatomic, assign) int moveSpeed;
@property (nonatomic, assign) int moveTime;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) CharacterType roleType;
@property (nonatomic, assign) int tag;

@property (nonatomic) SpriteStates state;

@property (readonly) CharacterSprite *sprite;
@property (nonatomic) SpriteDirections direction;
@property CGPoint position;

@property (nonatomic, retain) NSMutableArray *pointArray;

-(id) initWithFileName:(NSString *) filename player:(int)pNumber;

//-(void) addPosition:(CGPoint)velocity time:(ccTime)delta;
-(void) setCharacterWithVelocity:(CGPoint)velocity;

-(void) attackEnemy:(NSMutableArray*) enemies;
-(void) getDamage:(int) damage;
-(void) showAttackRange:(BOOL)visible;
-(void) end;

-(void) setPosition:(CGPoint)position;
-(CGPoint) position;

-(void) addStatus:(StatusType)type withTime:(int)time;
-(void) removeStatus:(StatusType)type;

- (id)initWithName:(NSString *)rname fileName:(NSString *)rfilename;

@end
