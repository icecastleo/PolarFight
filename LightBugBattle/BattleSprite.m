//
//  BattleSprite.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleSprite.h"
#import "BattleLayer.h"

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
        
        layer = (BattleLayer*)[self parent];
        [self makePoint];
        [self makePath];
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

-(void) makePoint
{
    pointArray=[NSMutableArray arrayWithObjects:
                [NSValue valueWithCGPoint:ccp(0, 32)],
                [NSValue valueWithCGPoint:ccp(32, 32)],
                [NSValue valueWithCGPoint:ccp(32, 0)],
                [NSValue valueWithCGPoint:ccp(0, 0)],nil];
    [pointArray retain];
    
}

-(void) makePath
{
    path=CGPathCreateMutable();
    CGPoint loc=[[pointArray objectAtIndex:0] CGPointValue];
    CGPathMoveToPoint(path, NULL, loc.x, loc.y);
    for (int i=1; i<[pointArray count]; i++) {
        CGPoint loc=[[pointArray objectAtIndex:i] CGPointValue];
        CGPathAddLineToPoint(path, NULL, loc.x, loc.y);
    }
    CGPathCloseSubpath(path);
    CGPathRetain(path);
    
}

-(void) setRandomAbility {
    hp = 30;
    
    attack = arc4random() % 4 + 3;
    defense = 3;
    speed = arc4random() % 7 + 3;
    
    moveSpeed = arc4random() % 3 + 4;
    moveTime = 3;
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
    
    // be attacked state;
    hp -= damage;
    
    if(hp <= 0) {
        state = stateDead;
        
        // dead animation + cleanup
        [self removeFromParentAndCleanup:YES];
    }
}

-(void) attackEnemy:(NSMutableArray *)enemies {
    
    CCLOG(@"Player %d's %@ is attack",player, name);
    
    state = stateAttack;
    
    NSMutableArray *attackPointArray;
    attackPointArray=[NSMutableArray arrayWithObjects:
                      [NSValue valueWithCGPoint:ccp(0, 32)],
                      [NSValue valueWithCGPoint:ccp(32, 32)],
                      [NSValue valueWithCGPoint:ccp(32, 64)],
                      [NSValue valueWithCGPoint:ccp(0, 64)],nil];
    
    
    
    
    CGMutablePathRef attackRange = CGPathCreateMutable();
    CGPoint loc=[[attackPointArray objectAtIndex:0] CGPointValue];
    CGPathMoveToPoint(attackRange, NULL, loc.x, loc.y);
    for (int i=1; i<[attackPointArray count]; i++) {
        CGPoint loc=[[attackPointArray objectAtIndex:i] CGPointValue];
        CGPathAddLineToPoint(attackRange, NULL, loc.x, loc.y);
    }
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
    
    for(int i = 0; i<[enemies count];i++)
    {
        BattleSprite *bs = ((BattleSprite*)[enemies objectAtIndex:i]);
        if(bs.player==player)
            continue;
        NSMutableArray *points=bs.pointArray;
        for (int j=0; j<[points count]; j++) {
            CGPoint loc=[[points objectAtIndex:j] CGPointValue];
            // switch coordinate systems
            loc=[bs convertToWorldSpace:loc];
            loc=[self convertToNodeSpace:loc];
            if (CGPathContainsPoint(attackRange, NULL, loc, NO)) {
               CCLOG(@"Player %i is under attack ",bs.player);
                break;
            }
        }
        
    }
    
}

-(void) end {
    // 回合結束
    state = stateIdle;
}

@end
