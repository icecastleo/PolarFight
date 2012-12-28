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
    
    NSMutableDictionary *attributeDictionary;
    NSMutableDictionary *statePremissionDictionary;
    
    NSMutableArray *passiveSkillArray;
}

@property (weak) BattleController *controller;
@property int player;

@property (readonly) CharacterType roleType;
//@property (readonly) AttackType attackType;
@property (readonly) ArmorType armorType;

@property (retain, readonly) NSString *name;
@property (retain, readonly) NSString *picFilename;

@property (readonly) int level;

@property (readonly) NSMutableDictionary *timeStatusDictionary;
@property (readonly) NSMutableDictionary *auraStatusDictionary;

// TODO: Move bloodsprite to hp attribute?
@property (readonly) CharacterSprite *sprite;

@property (readonly) CharacterState state;
@property (readonly) CharacterDirection direction;

@property (readwrite) CGPoint position;

@property (nonatomic, strong) NSMutableArray *pointArray;

-(id)initWithId:(NSString *)anId andLevel:(int)aLevel;

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

-(id)initWithXMLElement:(GDataXMLElement *)anElement;

-(void)addTimeStatus:(TimeStatusType)type withTime:(int)time;
//-(void)addAuraStatus:(StatusType)type;
-(void)removeTimeStatus:(TimeStatusType)type;

-(void)displayString:(NSString *)string withColor:(ccColor3B)color;
-(void)displayString:(NSString*)string R:(int)red G:(int)green B:(int)blue;

@end
