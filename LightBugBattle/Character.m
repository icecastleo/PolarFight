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

@implementation Character

@synthesize player,name,maxHp;
@synthesize hp, attack, defense, speed, moveSpeed, moveTime;
@synthesize state;
@synthesize sprite;
@synthesize position;
@synthesize pointArray;

+(id)characterWithController:(BattleController *)battleController player:(int)pNumber withFile:(NSString *)filename {
    return [[[self alloc] initWithController:battleController player:pNumber withFile:filename] autorelease];
}

-(id) initWithController:(BattleController *) battleController player:(int)pNumber withFile:(NSString *) filename {
    if(self = [super init]) {
        
        controller = battleController;
        name = filename;
        player = pNumber;
        
        [self setRandomAbility];

        sprite = [[CharacterSprite alloc] initWithCharacter:self];
        
        state = stateIdle;
        
        [self makePoint];
        
        skillSet = [[SkillSet alloc] initWithRangeName:self rangeName:@"RangeFanShape"];
//        attackType = [[CircleAttackType alloc] initWithSprite:self];
        
        context = UIGraphicsGetCurrentContext();
    }
    return self;
}

-(void) setAttackRotation:(float) offX:(float) offY
{
    [skillSet setRangeRotation:offX :offY];
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
    speed = arc4random() % 7 + 3;
    
    moveSpeed = arc4random() % 3 + 4;
    moveTime = arc4random() % 3 + 2;
}

// TODO: need be done at mapLayers
-(void)addPosition:(CGPoint)velocity time:(ccTime) delta{
    
    if(velocity.x == 0 && velocity.y == 0) {
        state = stateIdle;
        [sprite stopAllActions];
        return;
    }
    
    state = stateMove;
    
    sprite.position = ccpAdd(sprite.position, ccpMult(velocity, moveSpeed * 40 * delta ));
    [self setDirectionWithVelocity:velocity];
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
    [sprite setDirectionAnimate:direction];
}

-(void) getDamage:(int) damage {
    
    CCLOG(@"Player %i's %@ is under attacked, and it gets %d damage!", player, name, damage);
    
    // be attacked state;
    hp -= damage;
    [sprite setBloodSpriteWithCharacter:self];
    
    if(hp <= 0) {
        state = stateDead;
        
        // dead animation + cleanup
        
        [controller removeCharacter:self];
    }
}

-(void) attackEnemy:(NSMutableArray *)enemies {
    
    CCLOG(@"Player %d's %@ is attack",player, name);
    
    state = stateAttack;
    
    NSMutableArray *effectTargets = [skillSet getEffectTargets:enemies];

    for (Character *character in effectTargets) {
        [character getDamage:attack];
    }
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
    sprite.position = newPosition;
}

-(CGPoint)position {
    return sprite.position;
}

@end
