//
//  BattleCharacter.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//
//

#import "Character.h"
#import "BattleController.h"
#import "SkillKit.h"
#import "StatusKit.h"
#import "StatusFactory.h"
#import "PartyParser.h"

// TODO: Delete after test.
#import "RegenerationSkill.h"
#import "ReflectAttackDamageSkill.h"
#import "ContinuousAttackSkill.h"
#import "HealSkill.h"
#import "SwordmanSkill.h"
#import "WizardSkill.h"
#import "AssassinSkill.h"
#import "SlowMoveAura.h"
#import "TankSkill.h"
#import "SuicideSkill.h"
#import "BombPassiveSkill.h"

@implementation Character

@synthesize controller;
@synthesize player;
@synthesize level;
//@synthesize attackType;
@synthesize armorType;
@synthesize state;
@synthesize sprite,direction;
@synthesize timeStatusDictionary;
@synthesize pointArray;

@dynamic position;

// FIXME: fix name reference.
-(id)initWithId:(NSString *)anId andLevel:(int)aLevel {
    if ((self = [super init])) {
        
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
//        auraStatusDictionary = [[NSMutableDictionary alloc] init];
        attributeDictionary = [[NSMutableDictionary alloc] init];
        passiveSkillDictionary = [[NSMutableDictionary alloc] init];
        auraArray = [[NSMutableArray alloc] init];
        
        GDataXMLElement *characterElement = [PartyParser getNodeFromXmlFile:@"CharacterData.xml" tagName:@"character" tagAttributeName:@"id" tagId:anId];;
        
        //get tag's attributes
        for (GDataXMLNode *attribute in characterElement.attributes) {
            if ([attribute.name isEqualToString:@"name"]) {
                _name = attribute.stringValue;
            } else if ([attribute.name isEqualToString:@"img"]) {
                _picFilename = attribute.stringValue;
            }
        }
        
        //get tag's children
        for (GDataXMLElement *element in characterElement.children) {
            if ([element.name isEqualToString:@"attributes"]) {
                for (GDataXMLElement *attribute in element.children) {
                    Attribute *attr = [[Attribute alloc] initWithXMLElement:attribute];
                    [self addAttribute:attr];
                }
            }
            //TODO: skill part
            else if ([element.name isEqualToString:@"skill"]) {
                
            }
        }
        
        _characterId = anId;
        
        level = aLevel;
        
        sprite = [[CharacterSprite alloc] initWithCharacter:self];
        
        state = stateIdle;
        
        [self makePoint];
        
//        attackType = kAttackNoraml;
        armorType = kArmorNoraml;
        
        // TODO: Let change state or something to use this map...
        statePremissionDictionary = [[NSMutableDictionary alloc] init];
        
        [self setSkillForCharacter:_name];
        [self setPassiveSkillForCharacter:_name];
        
//        CCLOG(@"%@ is create",_name);s
    }
    return self;
}

-(void)setSkillForCharacter:(NSString *)name {
    if ([name isEqualToString:@"Swordsman"]) {
        skill = [[SwordmanSkill alloc] initWithCharacter:self];
    } else if ([name isEqualToString:@"Wizard"]) {
        skill = [[WizardSkill alloc] initWithCharacter:self];
    } else if ([name isEqualToString:@"Priest"]) {
        skill = [[HealSkill alloc] initWithCharacter:self];
    } else if ([name isEqualToString:@"Tank"]) {
        skill = [[TankSkill alloc] initWithCharacter:self];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:@[kRangeSideEnemy],@"rangeSides",kRangeTypeCircle,@"rangeType",@125,@"effectRadius",nil];
        
        SlowMoveAura *aura = [[SlowMoveAura alloc] initWithCharacter:self rangeDictionary:dictionary];
        
        [auraArray addObject:aura];
    } else if ([name isEqualToString:@"Bomber"]) {
        skill = [[SuicideSkill alloc] initWithCharacter:self];
    }
}

-(void)setPassiveSkillForCharacter:(NSString *)name {
    if ([name isEqualToString:@"Swordsman"]) {
        [self addPassiveSkill:[[ReflectAttackDamageSkill alloc] initWithProbability:20 reflectPercent:100]];
    } else if ([name isEqualToString:@"Wizard"]) {
        [self addPassiveSkill:[[AssassinSkill alloc] init]];
    } else if ([name isEqualToString:@"Priest"]) {
        [self addPassiveSkill:[[RegenerationSkill alloc] initWithValue:50]];
    } else if ([name isEqualToString:@"Bomber"]) {
        [self addPassiveSkill:[[BombPassiveSkill alloc] init]];
    }
}

-(id)initWithXMLElement:(GDataXMLElement *)anElement {
    NSString *tempId;
    NSString *tempLevel;
    for (GDataXMLNode *attribute in anElement.attributes) {
        if ([attribute.name isEqualToString:@"id"]) {
            tempId = attribute.stringValue;
        } else if ([attribute.name isEqualToString:@"level"]) {
            tempLevel = attribute.stringValue;
        }
    }
    
    self = [self initWithId:tempId andLevel:tempLevel.intValue];
    
    return self;
}

-(void)dealloc {
    // FIXME: Cleaned it when it is dead.
    [sprite removeFromParentAndCleanup:YES];
}

-(void)makePoint {
    pointArray=[NSMutableArray arrayWithObjects:
                [NSValue valueWithCGPoint:ccp(0, 32)],
                [NSValue valueWithCGPoint:ccp(32, 32)],
                [NSValue valueWithCGPoint:ccp(32, 0)],
                [NSValue valueWithCGPoint:ccp(0, 0)],nil];
}

-(void)addAttribute:(Attribute *)attribute {
    [attributeDictionary setObject:attribute forKey:[NSNumber numberWithInt:attribute.type]];
}

-(Attribute *)getAttribute:(CharacterAttributeType)type {
    return [attributeDictionary objectForKey:[NSNumber numberWithInt:type]];
}

-(BOOL)getCharacterStatePermission:(CharacterState)aState {
    NSNumber *result = [statePremissionDictionary objectForKey:[NSNumber numberWithInt:aState]];
    
    if(result == nil) {
        return YES;
    } else {
        return [result boolValue];
    }
}

// FIXME: Set default directionVelocity

//-(void)setDefault {
//    switch (direction) {
//        case kCharacterDirectionLeft:
//            [self setAttackRotationWithVelocity:ccp(-1, 0)];
//            break;
//        case kCharacterDirectionRight:
//            [self setAttackRotationWithVelocity:ccp(1, 0)];
//            break;
//        case kCharacterDirectionUp:
//            [self setAttackRotationWithVelocity:ccp(0, 1)];
//            break;
//        case kCharacterDirectionDown:
//            [self setAttackRotationWithVelocity:ccp(0, -1)];
//            break;
//        default:
//            [NSException raise:@"Character direction error." format:@"%d is not a correct direction value",direction];
//            ;
//    }
//}

-(void)setDirectionVelocity:(CGPoint)velocity {
    if(velocity.x == 0 && velocity.y == 0) {
        state = stateIdle;
        [sprite stopAllActions];
        return;
    }
    
    // Set here to keep privious velocity.
    _directionVelocity = velocity;
    
    state = stateMove;
    
    CharacterDirection newDirection = [self getDirectionByVelocity:velocity];
    
    if([sprite numberOfRunningActions] == 0 || direction != newDirection) {
        direction = newDirection;
        [sprite runDirectionAnimate];
    }

    [skill setRangeRotation:velocity.x :velocity.y];
}

-(CharacterDirection)getDirectionByVelocity:(CGPoint)velocity {
    if(fabsf(velocity.x) >= fabsf(velocity.y)) {
        if(velocity.x > 0) {
            return kCharacterDirectionRight;
        } else {
            return kCharacterDirectionLeft;
        }
    } else {
        if(velocity.y > 0) {
            return kCharacterDirectionUp;
        } else {
            return kCharacterDirectionDown;
        }
    }
}

//-(void)setAttackRotationWithVelocity:(CGPoint)velocity {
//    [skill setRangeRotation:velocity.x :velocity.y];
//}

-(void)useSkill {
    [sprite stopAllActions];
    
    CCLOG(@"Player %d's %@ is using skill",player, self.name);
    
    state = kCharacterStateUseSkill;
    // TODO: Run skill animation

    [skill execute];
    
    // TODO: Need to be called after skill animation
    [self finishAttack];
}

-(void)attackCharacter:(Character *)target withAttackType:(AttackType)type {
    // TODO: Define attack type.
    AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self attackType:type defender:target];
    
    [self sendAttackEvent:event];
}

-(void)sendAttackEvent:(AttackEvent *)event {
    for (NSString *key in passiveSkillDictionary) {
        PassiveSkill *p = [passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(character:willSendAttackEvent:)]) {
            [p character:self willSendAttackEvent:event];
        }
    }
    
    [event.defender receiveAttackEvent:event];
}

-(void)receiveAttackEvent:(AttackEvent *)event {
    for (NSString *key in passiveSkillDictionary) {
        PassiveSkill *p = [passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(character:willReceiveAttackEvent:)]) {
            [p character:self willReceiveAttackEvent:event];
        }
    }
    
    Attribute *defense = [attributeDictionary objectForKey:[NSNumber numberWithInt:kCharacterAttributeDefense]];
    
    if (defense != nil) {
        [event subtractAttack:defense.value];
    }
    
    [self receiveDamageEvent:[event convertToDamageEvent]];
}

-(void)receiveDamageEvent:(DamageEvent *)event {
    for (NSString *key in passiveSkillDictionary) {
        PassiveSkill *p = [passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(character:didReceiveDamageEvent:)]) {
            [p character:self didReceiveDamageEvent:event];
        }
    }
    
    [self receiveDamage:[event convertToDamage]];
}

-(void)receiveDamage:(Damage *)damage {
    CCLOG(@"Player %i's %@ gets %d damage!", player, self.name, damage.value);
    
    Attribute *hp = [attributeDictionary objectForKey:[NSNumber numberWithInt:kCharacterAttributeHp]];
    
    NSAssert(hp != nil, @"A character without hp gets damage...");
    
    [hp decreaseCurrentValue:damage.value];
    
    [self displayString:[NSString stringWithFormat:@"%d",damage.value] withColor:ccRED];
    
    for (NSString *key in passiveSkillDictionary) {
        PassiveSkill *p = [passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(character:didReceiveDamage:)]) {
            [p character:self didReceiveDamage:damage];
        }
    }
    
    state = kCharacterStateGetDamage;
    
    // Knock out effect
    if (controller != nil) {
        if (damage.type == kDamageTypeAttack) {
            CGPoint velocity = ccpSub(self.position, damage.damager.position);
            [controller knockOut:self velocity:velocity power:4];
        }
    }
    
    [sprite updateBloodSprite];
    
    if (hp.currentValue == 0) {
        [self dead];
    }
}

-(void)getHeal:(int)heal {
    Attribute *hp = [attributeDictionary objectForKey:[NSNumber numberWithInt:kCharacterAttributeHp]];
  
    NSAssert(hp != nil, @"A character without hp gets heal...");
    
    [hp increaseCurrentValue:heal];
    
    // FIXME: It may exceed the maxHp...
    [self displayString:[NSString stringWithFormat:@"+%d",heal] withColor:ccGREEN];
    
    [sprite updateBloodSprite];
    
    // TODO: When there is AI, there maybe need to change from dangerous to good state.
}

// TODO: Need to be called when attack animation finished
-(void)finishAttack {
    state = stateIdle;
}

-(void)dead {
    state = stateDead;
    
    for (NSString *key in passiveSkillDictionary) {
        PassiveSkill *p = [passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(characterWillRemoveDelegate:)]) {
            [p characterWillRemoveDelegate:self];
        }
    }
    
    // dead animation + cleanup
    if(controller)
        [controller removeCharacter:self];
}

-(void)handleRoundStartEvent {
    for (NSString *key in passiveSkillDictionary) {
        PassiveSkill *p = [passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(characterShouldStartRound:)]) {
            [p characterShouldStartRound:self];
        }
    }
    [skill showAttackRange:YES];
}

-(void)handleRoundEndEvent {
    [skill showAttackRange:NO];
    [sprite stopAllActions];
    state = stateIdle;
    
    for (NSString *key in passiveSkillDictionary) {
        PassiveSkill *p = [passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(characterDidRoundEnd:)]) {
            [p characterDidRoundEnd:self];
        }
    }
}

-(void)setPosition:(CGPoint)newPosition {
    sprite.position = newPosition;
}

-(CGPoint)position {
    return sprite.position;
}

-(void)addPassiveSkill:(PassiveSkill *)passiveSkill {
    // FIXME: For passive skill with duration, maybe there are some better way without allocing a new one to replace.
    // Fix it with static method is better (before alloc), but hard for extend class.
    
    NSString *key = NSStringFromClass([passiveSkill class]);
    
    // Check if there are already exist the same passive skill.
    PassiveSkill *old = [passiveSkillDictionary objectForKey:key];

    if (old != nil) {
        // Add duration time to the old one
        if (old.duration != 0 && passiveSkill.duration != 0) {
            old.duration = passiveSkill.duration;
            return;
        }
        
        [self removePassiveSkill:old key:key];
    }
    
    // Add passive skill
    if ([passiveSkill respondsToSelector:@selector(characterWillAddDelegate:)]) {
        [passiveSkill characterWillAddDelegate:self];
    }
    
    [passiveSkillDictionary setObject:passiveSkill forKey:key];
    
    passiveSkill.character = self;
}

-(void)removePassiveSkill:(PassiveSkill *)passiveSkill {
    [self removePassiveSkill:passiveSkill key:NSStringFromClass([passiveSkill class])];
}

-(void)removePassiveSkill:(PassiveSkill *)passiveSkill key:(NSString *)key {
    if ([passiveSkill respondsToSelector:@selector(characterWillRemoveDelegate:)]) {
        [passiveSkill characterWillRemoveDelegate:self];
    }
    [passiveSkillDictionary removeObjectForKey:key];
}

-(void)addTimeStatus:(TimeStatusType)type withTime:(int)time {
    TimeStatus *status = [timeStatusDictionary objectForKey:[NSNumber numberWithInt:type]];
    
    if (status == nil) {
        status = [StatusFactory createTimeStatus:type withTime:time toCharacter:self];
        [timeStatusDictionary setObject:status forKey:[NSNumber numberWithInt:type]];
    } else {
        [status addTime:time];
    }
}

-(void)removeTimeStatus:(TimeStatusType)type {
    [timeStatusDictionary removeObjectForKey:[NSNumber numberWithInt:type]];
}

-(CGRect)boundingBox {
    return sprite.boundingBox;
}

-(void)displayString:(NSString *)string withColor:(ccColor3B)color {
    CCLabelTTF *label = [CCLabelBMFont labelWithString:string fntFile:@"WhiteFont.fnt"];
    label.color = color;
    label.position =  ccp([self boundingBox].size.width / 2, [self boundingBox].size.height);
    label.anchorPoint = CGPointMake(0.5, 0);
    [self.sprite addChild:label];

    [label runAction:[CCSequence actions:
                      [CCScaleTo actionWithDuration:0.1f scale:1.3f],
                      [CCSpawn actions:
                       [CCScaleTo actionWithDuration:0.3f scale:0.1f],
                       [CCFadeOut actionWithDuration:0.3f],nil],
                      [CCCallFuncN actionWithTarget:self  selector:@selector(removeLabel:)],
                      nil]];
}

-(void)displayString:(NSString*)string R:(int)red G:(int)green B:(int)blue {
	[self displayString:string withColor:ccc3(red, green, blue)];
}

-(void)removeLabel:(id)sender {
	[sender removeFromParentAndCleanup:YES];
}

@end
