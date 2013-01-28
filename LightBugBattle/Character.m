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
#import "TestSkill.h"
#import "BombSkill.h"

@implementation Character

@synthesize player;
@synthesize level;
//@synthesize attackType;
@synthesize armorType;
@synthesize state;
@synthesize sprite,characterDirection;
@synthesize timeStatusDictionary;
@synthesize pointArray;

@synthesize direction = _direction;
@dynamic position,boundingBox,radius;

// FIXME: fix name reference.
-(id)initWithId:(NSString *)anId andLevel:(int)aLevel {
    if ((self = [super init])) {
        
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
//        auraStatusDictionary = [[NSMutableDictionary alloc] init];
        attributeDictionary = [[NSMutableDictionary alloc] init];
        _passiveSkillDictionary = [[NSMutableDictionary alloc] init];
        auraArray = [[NSMutableArray alloc] init];
        
        GDataXMLElement *characterElement = [PartyParser getNodeFromXmlFile:@"CharacterData.xml" tagName:@"character" tagAttributeName:@"id" tagAttributeValue:anId];;
        
        //get tag's attributes
        for (GDataXMLNode *attribute in characterElement.attributes) {
            if ([attribute.name isEqualToString:@"name"]) {
                _name = attribute.stringValue;
            } else if ([attribute.name isEqualToString:@"img"]) {
                _picFilename = attribute.stringValue;
            }else if ([attribute.name isEqualToString:@"headImage"]) {
                _headImageFileName = attribute.stringValue;
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
        
        _direction = ccp(0, -1);
        characterDirection = kCharacterDirectionDown;
        [skill setRangeDirection:_direction];
    }
    return self;
}

-(void)setSkillForCharacter:(NSString *)name {
    if ([name isEqualToString:@"Swordsman"]) {
        skill = [[SwordmanSkill alloc] initWithCharacter:self];
    } else if ([name isEqualToString:@"Assassin"]) {
        skill = [[TestSkill alloc] initWithCharacter:self];
    } else if ([name isEqualToString:@"Wizard"]) {
        skill = [[WizardSkill alloc] initWithCharacter:self];
    } else if ([name isEqualToString:@"Priest"]) {
        skill = [[HealSkill alloc] initWithCharacter:self];
    } else if ([name isEqualToString:@"Tank"]) {
        skill = [[TankSkill alloc] initWithCharacter:self];
        SlowMoveAura *aura = [[SlowMoveAura alloc] initWithCharacter:self];
        [auraArray addObject:aura];
    } else if ([name isEqualToString:@"Bomber"]) {
        skill = [[BombSkill alloc] initWithCharacter:self];
    }
}

-(void)setPassiveSkillForCharacter:(NSString *)name {
    if ([name isEqualToString:@"Swordsman"]) {
        [self addPassiveSkill:[[ReflectAttackDamageSkill alloc] initWithProbability:20 reflectPercent:100]];
    } else if ([name isEqualToString:@"Wizard"]) {
        [self addPassiveSkill:[[AssassinSkill alloc] init]];
    } else if ([name isEqualToString:@"Priest"]) {
        [self addPassiveSkill:[[RegenerationSkill alloc] initWithPercentValue:30]];
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
    
//    CCLOG(@"Player %d's %@ is dealloc",player, self.name);
}

-(void)makePoint {
    pointArray = [NSMutableArray arrayWithObjects:
                  [NSValue valueWithCGPoint:ccp(0, self.boundingBox.size.height/2)],
                  [NSValue valueWithCGPoint:ccp(0, self.boundingBox.size.height)],
                  [NSValue valueWithCGPoint:ccp(self.boundingBox.size.width/2, self.boundingBox.size.height)],
                  [NSValue valueWithCGPoint:ccp(self.boundingBox.size.width, self.boundingBox.size.height)],
                  [NSValue valueWithCGPoint:ccp(self.boundingBox.size.width, self.boundingBox.size.height/2)],
                  [NSValue valueWithCGPoint:ccp(self.boundingBox.size.width, 0)],
                  [NSValue valueWithCGPoint:ccp(self.boundingBox.size.width/2, 0)],
                  [NSValue valueWithCGPoint:ccp(0, 0)]
                  ,nil];
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

-(void)setDirection:(CGPoint)velocity {
    @synchronized(self) {
        if(velocity.x == 0 && velocity.y == 0) {
            state = stateIdle;
            [sprite stopAllActions];
            return;
        }
        
        // Set here to keep privious velocity.
        _direction = ccpNormalize(velocity);
        
        state = stateMove;
        
        CharacterDirection newDirection = [self getDirectionByVelocity:velocity];
        
        if([sprite numberOfRunningActions] == 0 || characterDirection != newDirection) {
            characterDirection = newDirection;
            [sprite runDirectionAnimate];
        }
        
        [skill setRangeDirection:velocity];
    }
}

-(CGPoint)direction {
    @synchronized(self) {
        return _direction;
    }
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
    
    // Run attack animation
    [sprite runAttackAnimate];

    [skill execute];
    
    // TODO: Need to be called after skill animation
//    [self finishAttack];
}

-(void)receiveAttackEvent:(AttackEvent *)event {
    NSAssert(event.defender == self, @"Wrong character receive the attack event!");
    
    for (NSString *key in event.attacker.passiveSkillDictionary) {
        PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(character:willSendAttackEvent:)]) {
            [p character:event.attacker willSendAttackEvent:event];
        }
    }
    
    for (NSString *key in _passiveSkillDictionary) {
        PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
        
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
    for (NSString *key in _passiveSkillDictionary) {
        PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
        
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
    
    [sprite updateBloodSprite];
    
    // Knock out effect
    if (damage.knockOutPower != 0) {
        CGPoint velocity = ccpSub(self.position, damage.location);
        [[BattleController currentInstance] knockOut:self velocity:velocity power:damage.knockOutPower collision:damage.knouckOutCollision];
    }
    
    if (hp.currentValue == 0) {
        [self dead];
    } else {
//        state = kCharacterStateGetDamage;
        
        for (NSString *key in _passiveSkillDictionary) {
            PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
            
            if ([p respondsToSelector:@selector(character:didReceiveDamage:)]) {
                [p  character:self didReceiveDamage:damage];
            }
        }
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

// Need to be called when attack animation finished
-(void)attackAnimateCallback {
    state = stateIdle;
}

-(void)dead {
    state = stateDead;
    
    //    CCLOG(@"Player %i's %@ is dead", player, self.name);

    // Run dead animation, then clean up
    [sprite runDeadAnimate];
    
    [[BattleController currentInstance] removeCharacter:self];
    
    for (NSString *key in _passiveSkillDictionary) {
        PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(characterWillRemoveDelegate:)]) {
            [p characterWillRemoveDelegate:self];
        }
    }
}

-(void)handleRoundStartEvent {
    for (NSString *key in _passiveSkillDictionary) {
        PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
        
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
    
    for (NSString *key in _passiveSkillDictionary) {
        PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
        
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

-(CGRect)boundingBox {
    return sprite.boundingBox;
}

-(float)radius {
    return sprite.boundingBox.size.width / 2;
}

-(void)addPassiveSkill:(PassiveSkill *)passiveSkill {
    // FIXME: For passive skill with duration, maybe there are some better way without allocing a new one to replace.
    // Fix it with static method is better (before alloc), but hard for extend class.
    
    NSString *key = NSStringFromClass([passiveSkill class]);
    
    // Check if there are already exist the same passive skill.
    PassiveSkill *old = [_passiveSkillDictionary objectForKey:key];

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
    
    [_passiveSkillDictionary setObject:passiveSkill forKey:key];
    
    passiveSkill.character = self;
}

-(void)removePassiveSkill:(PassiveSkill *)passiveSkill {
    [self removePassiveSkill:passiveSkill key:NSStringFromClass([passiveSkill class])];
}

-(void)removePassiveSkill:(PassiveSkill *)passiveSkill key:(NSString *)key {
    if ([passiveSkill respondsToSelector:@selector(characterWillRemoveDelegate:)]) {
        [passiveSkill characterWillRemoveDelegate:self];
    }
    [_passiveSkillDictionary removeObjectForKey:key];
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
