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
#import "ActiveSkill.h"
#import "Aura.h"
#import "SkillKit.h"
#import "BaseAI.h"
@class BattleController;

@interface Character : NSObject <XMLParsingDelegate> {
    NSMutableArray *pointArray;
//    TestSkill *skill;
    
    NSMutableDictionary *attributeDictionary;
    NSMutableDictionary *statePremissionDictionary;
    
    NSMutableArray *auraArray;
}

@property int player;
@property BaseAI *ai;
@property ActiveSkill *skill;
@property (readonly) CharacterType roleType;
//@property (readonly) AttackType attackType;
@property (readonly) ArmorType armorType;

@property (readonly) NSString *characterId;
@property (readonly) NSString *name;
@property (readonly) NSString *picFilename;
@property (readonly) NSString *headImageFileName;

@property (readonly) int level;

@property (readonly) NSMutableDictionary *passiveSkillDictionary;
@property (readonly) NSMutableDictionary *timeStatusDictionary;

@property (readonly) CharacterSprite *sprite;

@property (readonly) CharacterState state;
@property (readonly) CharacterDirection characterDirection;

@property CGPoint direction;
@property CGPoint position;

@property (readonly) float radius;
@property (readonly) CGRect boundingBox;

@property (nonatomic) NSMutableArray *pointArray;

-(id)initWithId:(NSString *)anId andLevel:(int)aLevel;
-(id)initWithXMLElement:(GDataXMLElement *)anElement;

-(void)addAttribute:(Attribute *)attribute;
-(Attribute*)getAttribute:(CharacterAttributeType)type;

-(void)update:(ccTime)delta;
-(void)setMoveDirection:(CGPoint)direction;

-(void)useSkill;
-(void)attackAnimateCallback;

-(void)receiveAttackEvent:(AttackEvent *)event;
-(void)receiveDamageEvent:(DamageEvent *)event;
-(void)getHeal:(int)heal;

-(void)handleRoundStartEvent;
-(void)handleRoundEndEvent;

-(void)addPassiveSkill:(PassiveSkill *)passiveSkill;
-(void)removePassiveSkill:(PassiveSkill *)passiveSkill;

-(void)addTimeStatus:(TimeStatusType)type withTime:(int)time;
//-(void)addAuraStatus:(StatusType)type;
-(void)removeTimeStatus:(TimeStatusType)type;

-(void)displayString:(NSString *)string withColor:(ccColor3B)color;

@end
