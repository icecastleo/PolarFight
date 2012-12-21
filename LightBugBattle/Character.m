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
#import "Role.h"
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
-(id)initWithName:(NSString *)aName fileName:(NSString *)aFilename andLevel:(int)aLevel {
    if ((self = [super init])) {
        _name = aName;
        _picFilename = aFilename;
        level = aLevel;
        
        sprite = [[CharacterSprite alloc] initWithCharacter:self];
        
        state = stateIdle;
        
        [self makePoint];
        
//        attackType = kAttackNoraml;
        armorType = kArmorNoraml;
        
        skill = [[TestSkill alloc] initWithCharacter:self rangeName:@"RangeLine"];
        
        context = UIGraphicsGetCurrentContext();
        
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
        auraStatusDictionary = [[NSMutableDictionary alloc] init];
        
        attributeDictionary = [[NSMutableDictionary alloc] init];
        
        passiveSkillArray = [[NSMutableArray alloc] init];
        
        // TODO: Let change state or something to use this map...
        statePremissionDictionary = [[NSMutableDictionary alloc] init];
        
        [self getAttributeFromRole:aName];
        
        [self addPassiveSkill:[[RegenerationSkill alloc] initWithValue:30]];
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

-(void)getAttributeFromRole:(NSString *)name
{
    // FIXME: Need to be deleted.
    
    NSArray *roles = [PartyParser getRolesArrayFromXMLFile];
    Role *role;
    
    for (Role *tempRole in roles) {
        if ([tempRole.name isEqualToString:name]) {
            role = tempRole;
            break;
        }
    }
    
    [self addAttribute:[[Attribute alloc] initWithType:kCharacterAttributeHp withQuadratic:0 withLinear:0 withConstantTerm:[role.hp integerValue]]];
    [self addAttribute:[[Attribute alloc] initWithType:kCharacterAttributeAttack withQuadratic:0 withLinear:0 withConstantTerm:[role.attack integerValue]]];
    [self addAttribute:[[Attribute alloc] initWithType:kCharacterAttributeDefense withQuadratic:0 withLinear:0 withConstantTerm:[role.defense integerValue]]];
    [self addAttribute:[[Attribute alloc] initWithType:kCharacterAttributeAgile withQuadratic:0 withLinear:0 withConstantTerm:[role.speed integerValue]]];
    [self addAttribute:[[Attribute alloc] initWithType:kCharacterAttributeSpeed withQuadratic:0 withLinear:0 withConstantTerm:[role.moveSpeed integerValue]]];
    [self addAttribute:[[Attribute alloc] initWithType:kCharacterAttributeTime withQuadratic:0 withLinear:0 withConstantTerm:[role.moveTime integerValue]]];
    
    //    maxHp     = [role.maxHp integerValue];
    //    currentHp        = [role.hp integerValue];
    //    attack    = [role.attack integerValue];
    //    defense   = [role.defense integerValue];
    //    speed     = [role.speed integerValue];
    //    moveSpeed = [role.moveSpeed integerValue];
    //    moveTime  = [role.moveTime integerValue];
}

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

@end
