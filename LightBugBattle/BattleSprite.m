//
//  BattleSprite.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleSprite.h"
#import "BattleLayer.h"
#import "FanShape.h"
#import "CircleAttackType.h"
@implementation BattleSprite

@synthesize player;
@synthesize hp, attack, defense, speed, moveSpeed, moveTime;
@synthesize state;
@synthesize pointArray;
//+(id) spriteWithRandomAbility {
//    return [[[BattleSprite alloc] initWithRandomAbility] autorelease];
//}
//
//-(id) initWithRandomAbility {
//    if(self = [super initWithFile:@"amg1_rt1.gif"]) {
//        hp = 30;
//
//        attack = arc4random() % 4 + 3;
//        defense = 3;
//        speed = arc4random() % 7 + 3;
//
//        moveSpeed = arc4random() % 3 + 4;
//        moveTime = 3;
//    }
//    return self;
//}

+(id) spriteWithFile:(NSString *)filename player:(int)player {
    return [[[BattleSprite alloc] initWithFile:filename player:player] autorelease];
}

-(id) initWithFile:(NSString *)filename player:(int) pNumber {
    if(self = [super initWithFile:[NSString stringWithFormat:@"%@_%@2.gif",filename, player == 1 ? @"rt" : @"lf"]]) {
        
        name = filename;
        player = pNumber;
        
        if(player == 1) {
            position_ = ccp(arc4random() % 200 + 21, arc4random() % 280 + 21);
        } else {
            position_ = ccp(arc4random() % 200 + 21 + 240, arc4random() % 280 + 21);
        }
        
        [self setRandomAbility];
        [self setAnimation];
        
        state = stateIdle;
        
        
        
        bloodSprite = [CCSprite spriteWithFile:@"blood.png"];
        bloodSprite.position = ccp([self boundingBox].size.width / 2, -[bloodSprite boundingBox].size.height - 2);
        [self addChild:bloodSprite];
        
        
        layer = (BattleLayer*)[self parent];
        [self makePoint];
        attackType = [[FanShape alloc] initWithSprite:self];
//        attackType = [[CircleAttackType alloc] initWithSprite:self];
        context = UIGraphicsGetCurrentContext();
//        upAnimate.duration = 0.3;
//        CCAnimation *animation = [CCAnimation animation];
//        
//        [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_fr1.gif",name]];
//        [animation addSpriteFrameWithFilename:[NSString stringWithFormat:@"%@_fr2.gif",name]];
//        animation.restoreOriginalFrame = NO;
//        animation.delayPerUnit = 0.1;
//        
//        upAnimate = [[CCAnimate alloc] initWithAnimation:animation];
//
//        
//        [self runAction:[CCRepeatForever actionWithAction:upAnimate]];
    }
    return self;
}

-(NSString*) getName
{
    return name;
}
-(void) setAttackRotation:(float) offX:(float) offY
{
    [attackType setRotation:offX :offY];
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

-(void)addPosition:(CGPoint)velocity time:(ccTime) delta{
    
    if(velocity.x == 0 && velocity.y == 0) {
        state = stateIdle;
        return;
    }
    
    state = stateMove;
    
    self.position = ccpAdd(self.position, ccpMult(velocity, moveSpeed * 40 * delta ));
    
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
    
    [self stopAllActions];
    
    direction = newDirection;
    
    if(direction == directionUp) {
        [self runAction:upAnimate];
    } else if (direction == directionDown) {
        [self runAction:downAnimate];
    } else if (direction == directionLeft) {
        [self runAction:leftAnimate];
    } else if (direction == directionRight) {
        [self runAction:rightAnimate];
    }
}

-(void) getDamage:(int) damage {
    
    CCLOG(@"Player %i's %@ is under attacked, and it gets %d damage!", player, name, damage);
    
    // be attacked state;
    hp -= damage;
    
    bloodSprite.scaleX = (float)hp / maxHp;
    bloodSprite.position = ccp([self boundingBox].size.width / 2 * bloodSprite.scaleX, bloodSprite.position.y);
    
    if(hp <= 0) {
        state = stateDead;
        
        // dead animation + cleanup
//        [self removeFromParentAndCleanup:YES];
        
        BattleLayer *bl = (BattleLayer*)[self parent];
        
        [bl removeSprite:self];
    }
}

-(void) attackEnemy:(NSMutableArray *)enemies {
    
    CCLOG(@"Player %d's %@ is attack",player, name);
    
    state = stateAttack;
    
    NSMutableArray *effectTargets = [attackType getEffectTargets:enemies];
    
    for (BattleSprite *sprite in effectTargets) {
        [sprite getDamage:attack];
    }
    
}

-(void) showAttackRange:(BOOL)visible
{
    attackType.rangeSprite.visible = visible;
}


-(void) end {
    // 回合結束
    state = stateIdle;
}

@end
