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
#import "AttackEventHandler.h"

// TODO: Delete after test.
#import "RegenerationSkill.h"

@implementation Character

@synthesize controller;
@synthesize player;
@synthesize level;
//@synthesize attackType;
@synthesize armorType;
//@synthesize maxHp, currentHp, attack, defense, speed, moveSpeed, moveTime;
@synthesize state;
@synthesize sprite,direction;
@synthesize position;
@synthesize timeStatusDictionary,auraStatusDictionary;
@synthesize pointArray;

// FIXME: fix name reference.
-(id)initWithId:(NSString *)anId andLevel:(int)aLevel {
    if ((self = [super init])) {
        
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
        auraStatusDictionary = [[NSMutableDictionary alloc] init];
        attributeDictionary = [[NSMutableDictionary alloc] init];
        passiveSkillArray = [[NSMutableArray alloc] init];
        
        GDataXMLElement *characterElement = [PartyParser getNodeFromXmlFile:@"CharacterData.xml" tagName:@"character" tagId:anId];;
        
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
        
        level = aLevel;
        
        sprite = [[CharacterSprite alloc] initWithCharacter:self];
        
        state = stateIdle;
        
        [self makePoint];
        
//        attackType = kAttackNoraml;
        armorType = kArmorNoraml;
        
//        skill = [[TestSkill alloc] initWithCharacter:self rangeName:@"RangeLine"];
        [self setSkillForCharacter:_name];
        
        context = UIGraphicsGetCurrentContext();
        
        // TODO: Let change state or something to use this map...
        statePremissionDictionary = [[NSMutableDictionary alloc] init];
        
//        [self addPassiveSkill:[[RegenerationSkill alloc] initWithValue:30]];
        [self setPassiveSkillForCharacter:_name];
    }
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

//-(void) setRandomAbility {
//    maxHp = 30;
//    currentHp = 30;
//
//    attack = arc4random() % 4 + 3;
//    defense = 3;
//    speed = arc4random() % 7 + 3;
//
//    moveSpeed = arc4random() % 3 + 4;
//    moveTime = arc4random() % 3 + 3;
//}

-(void)addAttribute:(Attribute *)attribute {
    [attributeDictionary setObject:attribute forKey:[NSNumber numberWithInt:attribute.type]];
}

-(Attribute *)getAttribute:(CharacterAttributeType)type {
    return [attributeDictionary objectForKey:[NSNumber numberWithInt:type]];
}

-(void)addPassiveSkill:(PassiveSkill *)aSkill {
    // TODO: How to handle the same skill? (some might have problem)
    [aSkill setOwner:self];
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

-(void)setCharacterStatePermission:(CharacterState)aState isPermission:(BOOL)aBool {
    // FIXME: What if more than one passisive skill wants to ban a state?
    // Use number to replace boolean?
    [statePremissionDictionary setObject:[NSNumber numberWithBool:aBool] forKey:[NSNumber numberWithInt:aState]];
}

-(void)setDefaultAttackRotation {
    switch (direction) {
        case kCharacterDirectionLeft:
            [self setAttackRotationWithVelocity:ccp(-1, 0)];
            break;
        case kCharacterDirectionRight:
            [self setAttackRotationWithVelocity:ccp(1, 0)];
            break;
        case kCharacterDirectionUp:
            [self setAttackRotationWithVelocity:ccp(0, 1)];
            break;
        case kCharacterDirectionDown:
            [self setAttackRotationWithVelocity:ccp(0, -1)];
            break;
        default:
            [NSException raise:@"Character direction error." format:@"%d is not a correct direction value",direction];
            ;
    }
}

-(void)setCharacterWithVelocity:(CGPoint)velocity {
    if(velocity.x == 0 && velocity.y == 0) {
        state = stateIdle;
        [sprite stopAllActions];
        return;
    }
    
    state = stateMove;
    
    [self setDirectionWithVelocity:velocity];
    [self setAttackRotationWithVelocity:velocity];
}

-(void)setDirectionWithVelocity:(CGPoint)velocity {
    CharacterDirection newDirection;
    
    if(fabsf(velocity.x) >= fabsf(velocity.y)) {
        if(velocity.x > 0) {
            newDirection = kCharacterDirectionRight;
        } else {
            newDirection = kCharacterDirectionLeft;
        }
    } else {
        if(velocity.y > 0) {
            newDirection = kCharacterDirectionUp;
        } else {
            newDirection = kCharacterDirectionDown;
        }
    }
    
    if(direction == newDirection && [sprite numberOfRunningActions] != 0) {
        return;
    }
    
    direction = newDirection;
    [sprite runDirectionAnimate];
}

-(void)setAttackRotationWithVelocity:(CGPoint)velocity {
    [skill setRangeRotation:velocity.x :velocity.y];
}

-(void)useSkill:(NSMutableArray *)characters {
    [sprite stopAllActions];
    
    CCLOG(@"Player %d's %@ is using skill",player, self.name);
    
    state = kCharacterStateUseSkill;
    // TODO: Run skill animation

    [skill doSkill:characters];
    
    // TODO: Need to be called after skill animation
    [self finishAttack];
}

-(void)attackCharacter:(Character *)target withAttackType:(AttackType)type {
    // TODO: Define attack type.
    AttackEvent *event = [[AttackEvent alloc] initWithAttacker:self attackType:type defender:target];
    
    [self handleSendAttackEvent:event];
}

-(void)handleSendAttackEvent:(AttackEvent *)event {
    for (PassiveSkill *p in passiveSkillArray) {
        if ([p respondsToSelector:@selector(handleSendAttackEvent:)]) {
            [p handleSendAttackEvent:event];
        }
    }
    
    [event.defender handleReceiveAttackEvent:event];
}

-(void)handleReceiveAttackEvent:(AttackEvent *)event {
    Attribute *defense = [attributeDictionary objectForKey:[NSNumber numberWithInt:kCharacterAttributeDefense]];
    
     CCLOG(@"%d",defense == nil);
    
    if (defense != nil) {
        [event subtractAttack:defense.value];
        CCLOG(@"%d",defense.value);
    }
    
    [self handleReceiveDamageEvent:[event convertToDamageEvent]];
}

-(void)handleReceiveDamageEvent:(DamageEvent *)event {
    for (PassiveSkill *p in passiveSkillArray) {
        if ([p respondsToSelector:@selector(handleReceiveDamageEvent:)]) {
            [p handleReceiveDamageEvent:event];
        }
    }
    
    CCLOG(@"Player %i's %@ gets %d damage!", player, self.name, event.damage);
    
    Attribute *hp = [attributeDictionary objectForKey:[NSNumber numberWithInt:kCharacterAttributeHp]];
    
    NSAssert(hp != nil, @"A character without hp gets damage...");
    
    [hp decreaseCurrentValue:event.damage];
    
    [self bloodHint:event.damage IsCreased:NO];
    
    for (PassiveSkill *p in passiveSkillArray) {
        if ([p respondsToSelector:@selector(handleReceiveDamage:)]) {
            [p handleReceiveDamage:event.damage];
        }
    }
    
    state = kCharacterStateGetDamage;
    
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
    [self bloodHint:heal IsCreased:YES];
    NSAssert(hp != nil, @"A character without hp gets heal...");
    
    [hp increaseCurrentValue:heal];
    [sprite updateBloodSprite];
    
    // TODO: When there is AI, there maybe need to change from dangerous to good state.
}

// TODO: Need to be called when attack animation finished
-(void)finishAttack {
    state = stateIdle;
}

-(void)showAttackRange:(BOOL)visible {
    [skill showAttackRange:visible];
}

-(void)handleRoundStartEvent {
    [skill showAttackRange:YES];
    
    for (PassiveSkill *p in passiveSkillArray) {
        if ([p respondsToSelector:@selector(handleRoundStartEvent)]) {
            [p handleRoundStartEvent];
        }
    }
}

-(void)handleRoundEndEvent {
    [skill showAttackRange:NO];
    [sprite stopAllActions];
    state = stateIdle;
    
    for (PassiveSkill *p in passiveSkillArray) {
        if ([p respondsToSelector:@selector(handleRoundEndEvent)]) {
            [p handleRoundEndEvent];
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

-(void)setSkillForCharacter:(NSString *)aName {
    if ([aName isEqualToString:@"Swordsman"]) {
        skill = [[TestSkill alloc] initWithCharacter:self rangeName:@"RangeLine"];
    }
}

-(void)setPassiveSkillForCharacter:(NSString *)aName {
    if ([aName isEqualToString:@"Swordsman"]) {
        [self addPassiveSkill:[[RegenerationSkill alloc] initWithValue:30]];
    }
}

-(void)bloodHint:(int)aValue IsCreased:(BOOL)increased {
    NSString *valueString = [[NSString alloc] initWithFormat:@"%d", aValue];
    if (increased) {
        [self displayMessage:valueString R:0 G:255 B:0];
    }else {
        [self displayMessage:valueString R:255 G:0 B:0];
    }
}

-(void)displayMessage:(NSString*)message R:(int)red G:(int)green B:(int)blue {
	CCLabelTTF *label = [CCLabelBMFont labelWithString:message fntFile:@"WhiteFont.fnt"];
    label.position =  ccp([self boundingBox].size.width / 2, [self boundingBox].size.height);
    label.anchorPoint = CGPointMake(0.5, 0);
    [self.sprite addChild:label z:1];
    [label setColor:(ccColor3B) {red, green, blue}];
    
	id scaleTo = [CCScaleTo actionWithDuration:0.1f scale:1.3f];
	id scaleBack = [CCScaleTo actionWithDuration:0.3f scale:0.1];
	id seq = [CCSequence actions:scaleTo, scaleBack, [CCCallFuncN actionWithTarget:self  selector:@selector(removeLabel:)], nil];
	[label runAction:seq];
    
}

-(void)removeLabel:(id)sender {
	[self.sprite removeChild:sender cleanup:YES];
}

@end
