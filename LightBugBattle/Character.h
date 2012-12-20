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
#import "AttackEvent.h"
#import "Attribute.h"
#import "PassiveSkill.h"
#import "DamageEvent.h"
#import "CharacterEventHandler.h"

@class BattleController;

@interface Character : NSObject<CharacterEventHandler> {
    NSMutableArray *pointArray;
    TestSkill *skill;
    CGContextRef context;
    
    NSMutableDictionary *attributeDictionary;
    NSMutableDictionary *statePremissionDictionary;
    
    NSMutableArray *passiveSkillArray;
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

// TODO: Move bloodsprite to hp attribute?
@property (readonly) CharacterSprite *sprite;

@property (readonly) CharacterState state;
@property (readonly) CharacterDirection direction;

@property CGPoint position;

@property (nonatomic, strong) NSMutableArray *pointArray;

-(id)initWithName:(NSString *)aName fileName:(NSString *)aFilename andLevel:(int)aLevel;

-(void)setAttribute:(Attribute*)anAttribute withType:(CharacterAttribute)type;
-(Attribute*)getAttribute:(CharacterAttribute)type;

-(void)addPassiveSkill:(PassiveSkill*)aSkill;

-(void)setCharacterStatePermission:(CharacterState)aState isPermission:(BOOL)aBool;
-(void)setCharacterWithVelocity:(CGPoint)velocity;

-(void)useSkill:(NSMutableArray*)characters;
-(void)attackCharacter:(Character*)target withAttackType:(AttackType)type;

// TODO: Does "CharacterEventHandler" need to add this method?
-(void)handleReceiveAttackEvent:(AttackEvent*)event;
-(void)getHeal:(int)heal;
-(void)showAttackRange:(BOOL)visible;

-(void)setPosition:(CGPoint)position;
-(CGPoint) position;

-(void)addTimeStatus:(TimeStatusType)type withTime:(int)time;
//-(void)addAuraStatus:(StatusType)type;
-(void)removeTimeStatus:(TimeStatusType)type;

@end
