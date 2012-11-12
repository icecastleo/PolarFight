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

@implementation Character

@synthesize controller;
@synthesize player,name,picFilename,maxHp;
@synthesize level, hp, attack, defense, speed, moveSpeed, moveTime;
@synthesize state;
@synthesize sprite,direction;
@synthesize position;
@synthesize pointArray;

//+(id) characterWithController:(BattleController *)battleController player:(int)pNumber withFile:(NSString *)filename {
//    return [[[self alloc] initWithController:battleController player:pNumber withFile:filename] autorelease];
//}

- (id)initWithName:(NSString *)rname fileName:(NSString *)rfilename roleType:(CharacterType)rType player:(int)pNumber level:(int)rlevel  maxHp:(int)rmaxHp hp:(int)rhp attack:(int)rattack defense:(int)rdefense speed:(int)rspeed moveSpeed:(int)rmoveSpeed moveTime:(int)rmoveTime;
{
    
    if ((self = [super init])) {
        name = rname;
        picFilename = rfilename;
        player = pNumber;
        _roleType = rType;
        level = rlevel;
        maxHp = rmaxHp;
        hp = rhp;
        attack = rattack;
        defense = rdefense;
        speed = rspeed;
        moveSpeed = rmoveSpeed;
        moveTime = rmoveTime;
        
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
        
        name = filename;
        player = pNumber;
        
        [self setRandomAbility];

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

-(void)dealloc {
    [pointArray release];
    [skillSet release];
    [statusDictionary release];
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
    
    CCLOG(@"Player %i's %@ is under attacked, and it gets %d damage!", player, name, damage);
    
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
    
    CCLOG(@"Player %d's %@ is attack",player, name);
    
    state = stateAttack;
    // TODO: Run attack animation
    
    NSMutableArray *effectTargets = [skillSet getEffectTargets:enemies];

    for (Character *character in effectTargets) {
        [character getDamage:attack];
    }
    
    // TODO: Need to be deleted when there has attack animation
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

-(void)addStatus:(StatusType)type withTime:(int)time {
    Status *temp;
    
    if ((temp = [statusDictionary objectForKey:[NSNumber numberWithInt:type]])) {
        if([temp isKindOfClass:[TimeStatus class]]) {
            TimeStatus *t = (TimeStatus*)temp;
            [t addTime:time];
        }
    } else {
        // TODO: put status in map.
    }
}

-(void)removeStatus:(StatusType)type {
    [statusDictionary removeObjectForKey:[NSNumber numberWithInt:type]];
}

@end
