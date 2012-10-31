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

@synthesize player;
@synthesize hp, attack, defense, speed, moveSpeed, moveTime;
@synthesize state;
@synthesize characterSprite;
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
        
        characterSprite = [CCSprite spriteWithFile:[NSString stringWithFormat:@"%@_%@2.gif",filename, player == 1 ? @"rt" : @"lf"]];
        
        bloodSprite = [CCSprite spriteWithFile:@"blood.png"];
        bloodSprite.position = ccp([characterSprite boundingBox].size.width / 2, -[bloodSprite boundingBox].size.height - 2);
        [characterSprite addChild:bloodSprite];
        
                
        [self setRandomAbility];
        [self setAnimation];
        
        state = stateIdle;
        
        [self makePoint];
        
        // FIXME: wait cloudsan!
        skillSet = [[SkillSet alloc] initWithRange:self range:NULL];
        
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

-(void) setAnimation {
    
    CCAnimation *animation = [CCAnimation animation];
    
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_bk1.gif",name]];
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_bk2.gif",name]];
    animation.restoreOriginalFrame = NO;
    animation.delayPerUnit = 0.5;
    
    upAnimate = [[CCAnimate alloc] initWithAnimation:animation];
    
    animation = [CCAnimation animation];
    
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_fr1.gif",name]];
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_fr2.gif",name]];
    
    animation.restoreOriginalFrame = NO;
    animation.delayPerUnit = 0.5;
    
    downAnimate = [[CCAnimate alloc] initWithAnimation:animation];
    
    
    animation = [CCAnimation animation];
    
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_lf1.gif",name]];
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_lf2.gif",name]];
    
    animation.restoreOriginalFrame = NO;
    animation.delayPerUnit = 0.5;
    
    leftAnimate = [[CCAnimate alloc] initWithAnimation:animation];
    
    
    animation = [CCAnimation animation];
    
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_rt1.gif",name]];
    [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_rt2.gif",name]];
    
    animation.restoreOriginalFrame = NO;
    animation.delayPerUnit = 0.1;
    
    rightAnimate = [[CCAnimate alloc] initWithAnimation:animation];
}

// TODO: need be done at mapLayers
-(void)addPosition:(CGPoint)velocity time:(ccTime) delta{
    
    if(velocity.x == 0 && velocity.y == 0) {
        state = stateIdle;
        return;
    }
    
    state = stateMove;
    
    characterSprite.position = ccpAdd(characterSprite.position, ccpMult(velocity, moveSpeed * 40 * delta ));
    
    if(fabsf(velocity.x) >= fabsf(velocity.y)) {
        if(velocity.x > 0) {
            [self setDirection:directionRight];
        } else {
            [self setDirection:directionLeft];
        }
    } else {
        if(velocity.y > 0) {
            [self setDirection:directionUp];
        } else {
            [self setDirection:directionDown];
        }
    }
}

-(void) setDirection:(SpriteDirections) newDirection {
    if(direction == newDirection) {
        return;
    }
    
    [characterSprite stopAllActions];
    
    direction = newDirection;
    
    if(direction == directionUp) {
        [characterSprite runAction:upAnimate];
    } else if (direction == directionDown) {
        [characterSprite runAction:downAnimate];
    } else if (direction == directionLeft) {
        [characterSprite runAction:leftAnimate];
    } else if (direction == directionRight) {
        [characterSprite runAction:rightAnimate];
    }
}

-(void) getDamage:(int) damage {
    
    CCLOG(@"Player %i's %@ is under attacked, and it gets %d damage!", player, name, damage);
    
    // be attacked state;
    hp -= damage;
    
    bloodSprite.scaleX = (float)hp / maxHp;
    bloodSprite.position = ccp([characterSprite boundingBox].size.width / 2 * bloodSprite.scaleX, bloodSprite.position.y);
    
    if(hp <= 0) {
        state = stateDead;
        
        // dead animation + cleanup
        
        [controller removeCharacter:self];
    }
}

-(void) attackEnemy:(NSMutableArray *)enemies {
    
    CCLOG(@"Player %d's %@ is attack",player, name);
    
    state = stateAttack;
    
//    NSMutableArray *effectTargets = [skillSet getEffectTargets:enemies];
//
//    for (Character *character in effectTargets) {
//        [character getDamage:attack];
//    }
}

-(void) showAttackRange:(BOOL)visible
{
    [skillSet showAttackRange:visible];
}


-(void) end {
    // 回合結束
    state = stateIdle;
}

-(void)setPosition:(CGPoint)newPosition {
    characterSprite.position = newPosition;
}

-(CGPoint)position {
    return characterSprite.position;
}

@end
