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

@implementation Character

@synthesize controller;
@synthesize player;
@synthesize level;
//@synthesize attackType;
@synthesize armorType;
@synthesize maxHp, currentHp, attack, defense, speed, moveSpeed, moveTime;
@synthesize state;
@synthesize sprite,direction;
@synthesize position;
@synthesize timeStatusDictionary,auraStatusDictionary;
@synthesize pointArray;

// FIXME: fix name reference.
- (id)initWithName:(NSString *)aName fileName:(NSString *)aFilename {
    if ((self = [super init])) {
        _name = aName;
        _picFilename = aFilename;
        
        level = 1;
        
        sprite = [[CharacterSprite alloc] initWithCharacter:self];
        
        state = stateIdle;
        
        [self makePoint];
        
//        attackType = kAttackNoraml;
        armorType = kArmorNoraml;
        
        skill = [[TestSkill alloc] initWithCharacter:self rangeName:@"RangeLine"];
        
        context = UIGraphicsGetCurrentContext();
        
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
        auraStatusDictionary = [[NSMutableDictionary alloc] init];
        
        // TODO: Let change state or something to use this map...
        statePremissionDictionary = [[NSMutableDictionary alloc] init];
        
        [self getAbilityFromRole:aName];
    }
    return self;
}

-(void)dealloc {
//    CCLOG(@"Player %i's %@ is dealloc.", player, self.name);
    [sprite removeFromParentAndCleanup:YES];
}

-(void) makePoint
{
    pointArray=[NSMutableArray arrayWithObjects:
                [NSValue valueWithCGPoint:ccp(0, 32)],
                [NSValue valueWithCGPoint:ccp(32, 32)],
                [NSValue valueWithCGPoint:ccp(32, 0)],
                [NSValue valueWithCGPoint:ccp(0, 0)],nil];
}


-(void) setRandomAbility {
    maxHp = 30;
    currentHp = 30;
    
    attack = arc4random() % 4 + 3;
    defense = 3;
    speed = arc4random() % 7 + 3;
    
    moveSpeed = arc4random() % 3 + 4;
    moveTime = arc4random() % 3 + 3;
}

-(void) getAbilityFromRole:(NSString *)name
{
    NSArray *roles = [PartyParser getRolesArrayFromXMLFile];
    Role *role;
    
    for (Role *tempRole in roles) {
        if ([tempRole.name isEqualToString:name]) {
            role = tempRole;
            break;
        }
    }
    
    maxHp     = [role.maxHp integerValue];
    currentHp        = [role.hp integerValue];
    attack    = [role.attack integerValue];
    defense   = [role.defense integerValue];
    speed     = [role.speed integerValue];
    moveSpeed = [role.moveSpeed integerValue];
    moveTime  = [role.moveTime integerValue];
}

//// TODO: need be done at mapLayers
//-(void)addPosition:(CGPoint)velocity time:(ccTime) delta{
//    
//    if(velocity.x == 0 && velocity.y == 0) {
//        state = stateIdle;
//        [sprite stopAllActions];
//        return;
//    }
//    
//    state = stateMove;
//    
//    sprite.position = ccpAdd(sprite.position, ccpMult(velocity, moveSpeed * 40 * delta ));
//    [self setDirectionWithVelocity:velocity];
//}

-(void) setDefaultAttackRotation {
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

-(void) setCharacterWithVelocity:(CGPoint)velocity {
    if(velocity.x == 0 && velocity.y == 0) {
        state = stateIdle;
        [sprite stopAllActions];
        return;
    }
    
    state = stateMove;
    
    [self setDirectionWithVelocity:velocity];
    [self setAttackRotationWithVelocity:velocity];
}

-(void) setDirectionWithVelocity:(CGPoint)velocity {
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

-(void) setAttackRotationWithVelocity:(CGPoint)velocity {
    [skill setRangeRotation:velocity.x :velocity.y];
}

-(void) attackEnemy:(NSMutableArray *)enemies {
    [sprite stopAllActions];
    
    CCLOG(@"Player %d's %@ is attack",player, self.name);
    
    state = stateAttack;
    // TODO: Run attack animation
    
//    NSMutableArray *effectTargets = [skill getEffectTargets:enemies];
//
//    // TODO: Replace by doSkill?
//    for (Character *character in effectTargets) {
//        [character getDamage:attack];
//    }

    [skill doSkill:enemies];
    
    // TODO: Need to be replaced when there has attack animation
    [self finishAttack];
}

-(void) getAttackEvent:(AttackEvent*)attackEvent {
    [AttackEventHandler handleAttackEvent:attackEvent toCharacter:self];
    
    [self getDamage:[attackEvent getDamage]];
}

-(void) getDamage:(int)damage {
    
    CCLOG(@"Player %i's %@ is under attacked, and it gets %d damage!", player, self.name, damage);
    
    // be attacked state;
    currentHp -= damage;
    
    if(currentHp > 0) {
        [sprite updateBloodSprite];
    } else { // currentHp <= 0
        state = stateDead;
        
        // dead animation + cleanup
        if(controller)
            [controller removeCharacter:self];
    }
}

// TODO: Need to be called when attack animation finished
-(void) finishAttack {
    state = stateIdle;
}

-(void) showAttackRange:(BOOL)visible {
    [skill showAttackRange:visible];
}

-(void) endRound {
    // TODO: Move this to battle controller.
    // 回合結束
    [sprite stopAllActions];
    state = stateIdle;
}

-(void)setPosition:(CGPoint)newPosition {
//    CGPoint velocity = ccp( newPosition.x - sprite.position.x , newPosition.y - sprite.position.y );
//    [self setDirectionWithVelocity:velocity];
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

-(BOOL)getCharacterStatePermission:(CharacterState)aState {
    NSNumber *result = [statePremissionDictionary objectForKey:[NSNumber numberWithInt:aState]];
    
    if(result == nil) {
        return YES;
    } else {
        return [result boolValue];
    }
}

-(void)setCharacterStatePermission:(CharacterState)aState isPermission:(BOOL)aBool {
    [statePremissionDictionary setObject:[NSNumber numberWithBool:aBool] forKey:[NSNumber numberWithInt:aState]];
}

@end
