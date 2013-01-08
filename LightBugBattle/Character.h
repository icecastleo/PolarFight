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
#import "AttackEvent.h"
#import "Attribute.h"
#import "PassiveSkill.h"
#import "DamageEvent.h"
#import "CharacterEventDelegate.h"
#import "PositiveSkill.h"
#import "Aura.h"
#import "AuraPassiveSkill.h"
#import "SkillKit.h"
@class BattleController;

@interface Character : NSObject <XMLParsingDelegate> {
    NSMutableArray *pointArray;
//    TestSkill *skill;
    PositiveSkill *skill;
    
    NSMutableDictionary *attributeDictionary;
    NSMutableDictionary *statePremissionDictionary;
    
    NSMutableArray *auraArray;
    NSMutableArray *passiveSkillArray;
//    NSMutableDictionary *auraPassiveSkillDictionary;
}

@property (weak) BattleController *controller;
@property int player;

@property (readonly) CharacterType roleType;
//@property (readonly) AttackType attackType;
@property (readonly) ArmorType armorType;

@property (readonly) NSString *characterId;
@property (retain, readonly) NSString *name;
@property (retain, readonly) NSString *picFilename;

@property (readonly) int level;

@property (readonly) NSMutableDictionary *timeStatusDictionary;
//@property (readonly) NSMutableDictionary *auraStatusDictionary;
@property (readonly) NSMutableDictionary *auraPassiveSkillDictionary;

// TODO: Move bloodsprite to hp attribute?
@property (readonly) CharacterSprite *sprite;

@property (readonly) CharacterState state;
@property (readonly) CharacterDirection direction;

@property (readwrite) CGPoint position;
@property (nonatomic, readwrite) CGPoint directionVelocity;

@property (nonatomic, strong) NSMutableArray *pointArray;

-(id)initWithId:(NSString *)anId andLevel:(int)aLevel;
-(id)initWithXMLElement:(GDataXMLElement *)anElement;

-(void)addAttribute:(Attribute *)attribute;
-(Attribute*)getAttribute:(CharacterAttributeType)type;

-(void)addPassiveSkill:(PassiveSkill *)aSkill;

//-(void)setDirectionVelocity:(CGPoint)velocity;

-(void)useSkill;
-(void)attackCharacter:(Character *)target withAttackType:(AttackType)type;

//-(void)receiveAttackEvent:(AttackEvent *)event;
-(void)receiveDamageEvent:(DamageEvent *)event;
-(void)getHeal:(int)heal;

-(void)handleRoundStartEvent;
-(void)handleRoundEndEvent;

//-(void)addAuraPassiveSkill:(AuraPassiveSkill *)aSkill;
//-(void)removeAuraPassiveSkill:(AuraPassiveSkill *)aSkill;

-(void)addTimeStatus:(TimeStatusType)type withTime:(int)time;
//-(void)addAuraStatus:(StatusType)type;
-(void)removeTimeStatus:(TimeStatusType)type;

-(void)displayString:(NSString *)string withColor:(ccColor3B)color;
-(void)displayString:(NSString *)string R:(int)red G:(int)green B:(int)blue;

@end
