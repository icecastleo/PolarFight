//
//  BattleCharacter.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CharacterSprite.h"
#import "SkillKit.h"
#import "AttackEvent.h"
#import "Attribute.h"

@class BattleController;

@interface Character : NSObject <xmlParsing>{
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
    
    NSMutableDictionary *attributeDictionary;
    NSMutableDictionary *statePremissionDictionary;
}
@property (weak) BattleController *controller;
@property (nonatomic) int player;

@property (readonly) CharacterType roleType;
//@property (readonly) AttackType attackType;
@property (readonly) ArmorType armorType;

@property (retain, readonly) NSString *name;
@property (retain, readonly) NSString *picFilename;

@property (readonly) int level;

//@property (readonly) int maxHp;
//@property (readonly) int currentHp;
//
//@property (readonly) int attack;
//@property (readonly) int defense;
//@property (readonly) int speed;
//@property (readonly) int moveSpeed;
//@property (readonly) int moveTime;

@property (readonly) NSMutableDictionary *timeStatusDictionary;
@property (readonly) NSMutableDictionary *auraStatusDictionary;
@property (readonly) CharacterSprite *sprite;

@property (readonly) CharacterState state;
@property (readonly) CharacterDirection direction;

@property CGPoint position;

@property (nonatomic, strong) NSMutableArray *pointArray;

-(id) initWithName:(NSString *)aName fileName:(NSString *)aFilename andLevel:(int)aLevel;

-(void)setAttribute:(Attribute*)anAttribute withType:(CharacterAttribute)type;
-(Attribute*)getAttribute:(CharacterAttribute)type;

-(void) setCharacterWithVelocity:(CGPoint)velocity;

-(void) attackEnemy:(NSMutableArray*)enemies;
-(void) getAttackEvent:(AttackEvent*)attackEvent;
-(void) getDamage:(int)damage;
-(void) showAttackRange:(BOOL)visible;
-(void) endRound;

-(void) setPosition:(CGPoint)position;
-(CGPoint) position;

-(void) addTimeStatus:(TimeStatusType)type withTime:(int)time;
//-(void) addAuraStatus:(StatusType)type;
-(void) removeTimeStatus:(TimeStatusType)type;

-(void) setCharacterStatePermission:(CharacterState)aState isPermission:(BOOL)aBool;

-(id)initWithDom:(GDataXMLElement *)dom;

@end
