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
#import "FileManager.h"

#import "SimpleAI.h"

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
#import "BombSkill.h"
#import "HeroSkill.h"

@implementation Character

@synthesize skill;
//@synthesize attackType;
@synthesize armorType;
@synthesize state;
@synthesize sprite,characterDirection;
@synthesize timeStatusDictionary;
@synthesize pointArray;

@synthesize level = _level;
@synthesize direction = _direction;
@synthesize position = _position;

@dynamic boundingBox;

// FIXME: fix name reference.
-(id)initWithId:(NSString *)anId andLevel:(int)aLevel {
    if ((self = [super init])) {
        _characterId = anId;
        _level = aLevel;
        
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
        
        // FIXME: Delete aura array and use dictionary
//        auraStatusDictionary = [[NSMutableDictionary alloc] init];
        attributeDictionary = [[NSMutableDictionary alloc] init];
        _passiveSkillDictionary = [[NSMutableDictionary alloc] init];
        auraArray = [[NSMutableArray alloc] init];
        
        NSDictionary *characterData = [[FileManager sharedFileManager] getCharacterDataWithId:anId];
        _name = [characterData objectForKey:@"name"];
        _spriteFile = [characterData objectForKey:@"image"];
        _headImageFileName = [characterData objectForKey:@"headImage"];
        _cost = [[characterData objectForKey:@"cost"] intValue];
        
        NSArray *attributes = [characterData objectForKey:@"attributes"];
        
        for (NSDictionary *dic in attributes) {
            Attribute *attr = [[Attribute alloc] initWithDictionary:dic];
            [attr updateValueWithLevel:self.level];
            [self addAttribute:attr];
        }
        
        // FIXME: Add price to character data
        float updatePrice = 30;
        
        Attribute *attr = [[Attribute alloc] initWithType:kCharacterAttributeUpdatePrice withQuadratic:updatePrice/10 withLinear:updatePrice withConstantTerm:0];
        [attr updateValueWithLevel:self.level];
        [self addAttribute:attr];
        
        // FIXME: Delete aura array and use dictionary
//        auraStatusDictionary = [[NSMutableDictionary alloc] init];
        auraArray = [[NSMutableArray alloc] init];
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
        
        sprite = [[CharacterSprite alloc] initWithCharacter:self];
        
        // FIXME: Group to a function, and run idle animation.
        state = kCharacterStateIdle;
        
        [self makePoint];
        
//        attackType = kAttackNoraml;
        armorType = kArmorNoraml;
        
        // TODO: Let change state or something to use this map...
        statePremissionDictionary = [[NSMutableDictionary alloc] init];
        
        [self setSkillForCharacter:_name];
        [self setPassiveSkillForCharacter:_name];
        
        // FIXME: set direction with init parameter?
        self.direction = ccp(0, -1);
        
        // FIXME: merge with barrier?
        // FIXME: Change to ellipse
        _radius = self.boundingBox.size.height / kShadowHeightDivisor / 2;
    }
    return self;
}

-(void)setLevel:(int)level {
    _level = level;
    
    for (id key in attributeDictionary) {
        Attribute *att = [attributeDictionary objectForKey:key];
        [att updateValueWithLevel:level];
    }
}

-(int)level {
    return _level;
}

-(void)setSkillForCharacter:(NSString *)name {
    if ([self.characterId intValue] < 200) {
        NSString *suffix = [name substringFromIndex:name.length - 2];
        
        if ([suffix intValue] % 2 == 1) {
            skill = [[SwordmanSkill alloc] initWithCharacter:self];
        } else {
            skill = [[TestSkill alloc] initWithCharacter:self];
        }
    } else if ([name hasPrefix:@"hero"]) {
        skill = [[HeroSkillnitWithCharacter:self];
    }
}

-(void)setPassiveSkillForCharacter:(NSString *)name {
    if ([name isEqualToString:@"Swordsman"]) {
        [self addPassiveSkill:[[ReflectAttackDamageSkill alloc] initWithProbability:20 reflectPercent:100]];
    } else if ([name isEqualToString:@"Wizard"]) {
        [self addPassiveSkill:[[AssassinSkill alloc] init]];
    } else if ([name isEqualToString:@"Priest"]) {
        [self addPassiveSkill:[[RegenerationSkill alloc] initWithPercentValue:25]];
    }  else if ([name isEqualToString:@"Tank"]) {
        SlowMoveAura *aura = [[SlowMoveAura alloc] initWithCharacter:self];
        [auraArray addObject:aura];
    } else if ([name isEqualToString:@"Bomber"]) {
        [self addPassiveSkill:[[BombPassiveSkill alloc] init]];
    } else if ([name isEqualToString:@"Archer"]) {
        [self addPassiveSkill:[[ContinuousAttackSkill alloc] initWithPercent:20]];
    }
}

-(void)dealloc {
    CCLOG(@"Player %d's %@ is dealloc",_player, self.name);
}

-(void)makePoint {
    pointArray = [NSMutableArray arrayWithObjects:
                  [NSValue valueWithCGPoint:ccp(0, self.boundingBox.size.height)],
                  [NSValue valueWithCGPoint:ccp(self.boundingBox.size.width, self.boundingBox.size.height)],
                  [NSValue valueWithCGPoint:ccp(self.boundingBox.size.width, 0)],
                  [NSValue valueWithCGPoint:ccp(0, 0)]
                  ,nil];
    
    int count = (int)self.boundingBox.size.height / kCollisionPointRange;
    
    for (int i = 1; i <= count; i++) {
        [pointArray addObject:[NSValue valueWithCGPoint:ccp(0, i * kCollisionPointRange)]];
        [pointArray addObject:[NSValue valueWithCGPoint:ccp(self.boundingBox.size.width, i * kCollisionPointRange)]];
    }
    
    count = (int)self.boundingBox.size.width / kCollisionPointRange;
    
    for (int i = 1; i <= count; i++) {
        [pointArray addObject:[NSValue valueWithCGPoint:ccp(i * kCollisionPointRange, 0)]];
        [pointArray addObject:[NSValue valueWithCGPoint:ccp(i * kCollisionPointRange, self.boundingBox.size.height)]];
    }
}

//-(void)setPlayer:(int)player {
//    _player = player;
//    
//    // FIXME: Decide by sprite
//    if (player == 2) {
//        sprite.flipX = YES;
//    }
//}

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

-(void)update:(ccTime)delta {
    if (state == kCharacterStateIdle || state == kCharacterStateMove) {
        [_ai AIUpdate];
    }
    
    if (state == kCharacterStateMove) {
        [[BattleController currentInstance] moveCharacter:self byPosition:ccpMult(self.direction, [self getAttribute:kCharacterAttributeSpeed].value * kMoveMultiplier * delta) isMove:YES];
    }
    
    
}

-(void)setMoveDirection:(CGPoint)direction {
    if (state != kCharacterStateIdle && state != kCharacterStateMove) {
        return;
    }
    
    if (direction.x == 0 && direction.y == 0) {
        if (state == kCharacterStateIdle) {
            return;
        }
        
        state = kCharacterStateIdle;
        // TODO: Run idle animation
            
        // FIXME: Move to idle animation.
        [sprite stopAllActions];
        return;
    }
    
    CharacterDirection old = characterDirection;
    
    // It will set the direction velocity
    [self setDirection:ccpNormalize(direction)];
    
    if(characterDirection != old || [sprite numberOfRunningActions] == 0) {
        [sprite runWalkAnimate];
    }
    
    state = kCharacterStateMove;
}

-(void)setDirection:(CGPoint)velocity {
    @synchronized(self) {
//        CCLOG(@"%f %f = %f",velocity.x , velocity.y, roundf(ccpLength(velocity)));
        NSAssert(roundf(ccpLength(velocity)) == 1, @"Direction should be a normalize velocity!");
        
        _direction = velocity;
        [skill setRangeDirection:velocity];        
        characterDirection = [self getDirectionByVelocity:velocity];
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

-(void)useSkill {
    CCLOG(@"Player %d's %@ is using skill",_player, self.name);
    
    // FIXME: If skill is cooldown or ?, it can't be true
    state = kCharacterStateUseSkill;
    
    [skill execute];
}

// Need to be called when attack animation finished
-(void)attackAnimateCallback {
    if (skill.hasNext) {
        [skill next];
        [skill execute];
    } else {
        [skill reset];
        state = kCharacterStateIdle;
    }
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
    @synchronized(self) {
        if (state == kCharacterStateDead) {
            return;
        }
        
        CCLOG(@"Player %i's %@ gets %d damage!",_player, self.name, damage.value);
        
        Attribute *hp = [attributeDictionary objectForKey:[NSNumber numberWithInt:kCharacterAttributeHp]];
        
        NSAssert(hp != nil, @"A character without hp gets damage...");
        
        hp.currentValue -= damage.value;
        
        [self displayString:[NSString stringWithFormat:@"%d",damage.value] withColor:ccRED];
        
        [sprite updateBloodSprite];
        
        // Knock out effect
        if (damage.knockOutPower != 0) {
            CGPoint velocity = ccpSub(self.position, damage.position);
            [[BattleController currentInstance] knockOut:self velocity:velocity power:damage.knockOutPower collision:damage.knouckOutCollision];
        }
        
        if (hp.currentValue == 0) {
            [self dead];
        } else {
            // state = kCharacterStateGetDamage;
            
            // TODO: Damage animate callback?
            // TODO: Damage animation
            [sprite runDamageAnimate:damage];
            
            for (NSString *key in _passiveSkillDictionary) {
                PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
                
                if ([p respondsToSelector:@selector(character:didReceiveDamage:)]) {
                    [p  character:self didReceiveDamage:damage];
                }
            }
        }
    }
}

//-(void)damageAnimateCallback {
//    state = kCharacterStateIdle;
//}

-(void)getHeal:(int)heal {    
    Attribute *hp = [attributeDictionary objectForKey:[NSNumber numberWithInt:kCharacterAttributeHp]];
  
    NSAssert(hp != nil, @"A character without hp gets heal...");
    
    hp.currentValue += heal;
    
    // FIXME: It may exceed the maxHp...
    [self displayString:[NSString stringWithFormat:@"+%d",heal] withColor:ccGREEN];
    
    [sprite updateBloodSprite];
    
    // TODO: When there is AI, there maybe need to change from dangerous to good state.
}

-(void)dead {
    state = kCharacterStateDead;
    
//    CCLOG(@"Player %i's %@ is dead",_player, self.name);

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

-(void)deadAnimateCallback {
    [sprite removeFromParentAndCleanup:YES];
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
    state = kCharacterStateIdle;
    
    for (NSString *key in _passiveSkillDictionary) {
        PassiveSkill *p = [_passiveSkillDictionary objectForKey:key];
        
        if ([p respondsToSelector:@selector(characterDidRoundEnd:)]) {
            [p characterDidRoundEnd:self];
        }
    }
}

-(void)setPosition:(CGPoint)position {
    @synchronized(self) {
        _position = position;
        sprite.position = ccp(position.x, position.y - self.radius + sprite.boundingBox.size.height / 2);
    }
}

-(CGPoint)position {
    @synchronized(self) {
        return _position;
    }
}

-(CGRect)boundingBox {
    return sprite.boundingBox;
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

-(void)removeLabel:(id)sender {
	[sender removeFromParentAndCleanup:YES];
}

@end
