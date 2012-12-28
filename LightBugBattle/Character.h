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
#import "PassiveSkill.h"
#import "DamageEvent.h"
#import "CharacterEventDelegate.h"

@class BattleController;

@interface Character : NSObject <XMLParsingDelegate> {
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

-(void)addAttribute:(Attribute*)attribute;
-(Attribute*)getAttribute:(CharacterAttributeType)type;

-(void)addPassiveSkill:(PassiveSkill*)aSkill;

-(void)setCharacterStatePermission:(CharacterState)aState isPermission:(BOOL)aBool;
-(void)setCharacterWithVelocity:(CGPoint)velocity;

-(void)useSkill;
-(void)attackCharacter:(Character*)target withAttackType:(AttackType)type;

-(void)receiveAttackEvent:(AttackEvent*)event;
-(void)receiveDamageEvent:(DamageEvent *)event;
-(void)getHeal:(int)heal;

-(void)handleRoundStartEvent;
-(void)handleRoundEndEvent;

-(void)setPosition:(CGPoint)position;
-(CGPoint) position;

-(id)initWithXMLElement:(GDataXMLElement *)aElement;

-(void)addTimeStatus:(TimeStatusType)type withTime:(int)time;
//-(void)addAuraStatus:(StatusType)type;
-(void)removeTimeStatus:(TimeStatusType)type;

@end
