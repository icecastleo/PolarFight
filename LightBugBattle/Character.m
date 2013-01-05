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

@implementation Character

@synthesize controller;
@synthesize player;
@synthesize level;
//@synthesize attackType;
@synthesize armorType;
//@synthesize maxHp, currentHp, attack, defense, speed, moveSpeed, moveTime;
@synthesize state;
@synthesize sprite,direction;
@synthesize timeStatusDictionary,auraStatusDictionary;
@synthesize pointArray;

@dynamic position;

// FIXME: fix name reference.
-(id)initWithId:(NSString *)anId andLevel:(int)aLevel {
    if ((self = [super init])) {
        
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
        auraStatusDictionary = [[NSMutableDictionary alloc] init];
        attributeDictionary = [[NSMutableDictionary alloc] init];
        passiveSkillArray = [[NSMutableArray alloc] init];
        
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
    }
}

-(void)setPassiveSkillForCharacter:(NSString *)name {
    if ([name isEqualToString:@"Swordsman"]) {
        [self addPassiveSkill:[[ReflectAttackDamageSkill alloc] initWithProbability:20 damagePercent:100]];
    } else if ([name isEqualToString:@"Wizard"]) {
        [self addPassiveSkill:[[ContinuousAttackSkill alloc] initWithBonusPercent:20]];
    } else if ([name isEqualToString:@"Priest"]) {
        [self addPassiveSkill:[[RegenerationSkill alloc] initWithValue:10]];
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

-(void)addPassiveSkill:(PassiveSkill *)aSkill {
    // TODO: How to handle the same skill? (some might have problem)
    [passiveSkillArray addObject:aSkill];
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
    for (PassiveSkill *p in passiveSkillArray) {
        if ([p respondsToSelector:@selector(character:willSendAttackEvent:)]) {
            [p character:self willSendAttackEvent:event];
        }
    }
    
    [event.defender receiveAttackEvent:event];
}

-(void)receiveAttackEvent:(AttackEvent *)event {
    Attribute *defense = [attributeDictionary objectForKey:[NSNumber numberWithInt:kCharacterAttributeDefense]];
    
    if (defense != nil) {
        event.bonus -= defense.value;
    }
    
    [self receiveDamageEvent:[event convertToDamageEvent]];
}

-(void)receiveDamageEvent:(DamageEvent *)event {
    for (PassiveSkill *p in passiveSkillArray) {
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
    
    for (PassiveSkill *p in passiveSkillArray) {
        if ([p respondsToSelector:@selector(character:didReceiveDamage:)]) {
            [p character:self didReceiveDamage:damage];
        }
    }
    
    state = kCharacterStateGetDamage;
    
    // Knock out effect
    if (controller != nil) {
        if (damage.type == kDamageTypeAttack) {
            CGPoint velocity = ccpSub(self.position, damage.damager.position);
            [controller knockOut:self velocity:velocity];
        }
    }
    
    if (hp.currentValue > 0) {
        [sprite updateBloodSprite];
    } else { // currentHp <= 0
        state = stateDead;
        
        // dead animation + cleanup
        if(controller)
            [controller removeCharacter:self];
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

-(void)handleRoundStartEvent {
    for (PassiveSkill *p in passiveSkillArray) {
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
    
    for (PassiveSkill *p in passiveSkillArray) {
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

-(void)update {
    NSMutableArray *removedKeys = [NSMutableArray array];
    
    for (TimeStatus *status in timeStatusDictionary) {
        [status update];
        
        if(status.isDead)
            [removedKeys addObject:[NSNumber numberWithInt:status.type]];
    }
    
    [timeStatusDictionary removeObjectsForKeys:removedKeys];
    
    [removedKeys removeAllObjects];
    
    for (AuraStatus *status in auraStatusDictionary) {
        [status updateCharacter:self];
        
        if(status.isDead)
            [removedKeys addObject:[NSNumber numberWithInt:status.type]];
    }
    
    [auraStatusDictionary removeObjectsForKeys:removedKeys];
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
