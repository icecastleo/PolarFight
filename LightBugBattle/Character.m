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

@implementation Character

@synthesize controller;
@synthesize player,name,maxHp;
@synthesize hp, attack, defense, speed, moveSpeed, moveTime;
@synthesize attackBonus,attackMultiplier;
@synthesize state;
@synthesize sprite,direction;
@synthesize position;
@synthesize timeStatusDictionary,auraStatusDictionary;
@synthesize pointArray;

+(id) characterWithFileName:(NSString *) filename player:(int)pNumber {
    return [[[self alloc] initWithFileName:filename player:pNumber] autorelease];
}

//FIXME: fix name reference.
- (id)initWithName:(NSString *)rname fileName:(NSString *)rfilename
{
    if ((self = [super init])) {
        //_name = @"test";
        _name =rname;
        _picFilename = rfilename;
        
        sprite = [[CharacterSprite alloc] initWithCharacter:self];
        
        state = stateIdle;
        
        [self makePoint];
        
        skillSet = [[SkillSet alloc] initWithRangeName:self rangeName:@"RangeFanShape"];
        //        attackType = [[CircleAttackType alloc] initWithSprite:self];
        
        context = UIGraphicsGetCurrentContext();
        
        statusDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
    
}

-(id) initWithFileName:(NSString *) filename player:(int)pNumber{
    if(self = [super init]) {
        
        _name = filename;
        player = pNumber;
        
        [self setRandomAbility];

        sprite = [[CharacterSprite alloc] initWithCharacter:self];
        
        state = stateIdle;
        
        [self makePoint];
        
        skillSet = [[SkillSet alloc] initWithRangeName:self rangeName:@"RangeFanShape"];
//        attackType = [[CircleAttackType alloc] initWithSprite:self];
        
        context = UIGraphicsGetCurrentContext();
        
        timeStatusDictionary = [[NSMutableDictionary alloc] init];
        auraStatusDictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc {
    [pointArray release];
    [skillSet release];
    [timeStatusDictionary release];
    [auraStatusDictionary release];
    [sprite removeFromParentAndCleanup:YES];
    [super dealloc];
}

-(void) setAttackRotationWithVelocity:(CGPoint)velocity
{
    [skillSet setRangeRotation:velocity.x :velocity.y];
}

-(void) makePoint
{
    pointArray=[NSMutableArray arrayWithObjects:
                [NSValue valueWithCGPoint:ccp(0, 32)],
                [NSValue valueWithCGPoint:ccp(32, 32)],
                [NSValue valueWithCGPoint:ccp(32, 0)],
                [NSValue valueWithCGPoint:ccp(0, 0)],nil];
    [pointArray retain];
}


-(void) setRandomAbility {
    maxHp = 30;
    hp = 30;
    
    attack = arc4random() % 4 + 3;
    defense = 3;
    speed = arc4random() % 10 + 3;
    
    moveSpeed = arc4random() % 3 + 4;
    moveTime = arc4random() % 2 + 7;
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

-(void) setCharacterWithVelocity:(CGPoint)velocity {
    if(velocity.x == 0 && velocity.y == 0) {
        state = stateIdle;
        [sprite stopAllActions];
        return;
    }
    
    state = stateMove;
//    sprite.position = ccpAdd(sprite.position, ccpMult(velocity, moveSpeed * 40 * delta ));
    [self setDirectionWithVelocity:velocity];
    [self setAttackRotationWithVelocity:velocity];
}

-(void) setDirectionWithVelocity:(CGPoint)velocity {
    SpriteDirections newDirection;
    
    if(fabsf(velocity.x) >= fabsf(velocity.y)) {
        if(velocity.x > 0) {
            newDirection = directionRight;
        } else {
            newDirection = directionLeft;
        }
    } else {
        if(velocity.y > 0) {
            newDirection = directionUp;
        } else {
            newDirection = directionDown;
        }
    }
    
    if(direction == newDirection && [sprite numberOfRunningActions] != 0) {
        return;
    }
    
    direction = newDirection;
    [sprite runDirectionAnimate];
}

-(void) getDamage:(int) damage {
    // TODO: Replace damage to attack info
    
    NSAssert([self.name isKindOfClass:[NSString class]], @"name is not a NSString");
    CCLOG(@"Player %i's %@ is under attacked, and it gets %d damage!", player, self.name, damage);
    
    // be attacked state;
    hp -= damage;
    [sprite updateBloodSprite];
    
    if(hp <= 0) {
        state = stateDead;
        
        // dead animation + cleanup
        if(controller)
            [controller removeCharacter:self];
    }
}

-(void) attackEnemy:(NSMutableArray *)enemies {
    [sprite stopAllActions];
    
    NSAssert([self.name isKindOfClass:[NSString class]], @"name is not a NSString");
    CCLOG(@"Player %d's %@ is attack",player, self.name);
    
    state = stateAttack;
    // TODO: Run attack animation
    
    NSMutableArray *effectTargets = [skillSet getEffectTargets:enemies];

    // TODO: Replace by doSkill?
    for (Character *character in effectTargets) {
        [character getDamage:attack];
    }
    
    // TODO: Need to be replaced when there has attack animation
    [self finishAttack];
}

// TODO: Need to be called when attack animation finished
-(void) finishAttack {
    state = stateIdle;
}

-(void) showAttackRange:(BOOL)visible {
    [skillSet showAttackRange:visible];
}

-(void) end {
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
    NSMutableArray *removedKeys = [[NSMutableArray alloc] init];
    
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

- (CGRect) boundingBox
{
    return sprite.boundingBox;
}

@end
