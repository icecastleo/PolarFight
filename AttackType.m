//
//  AttackType.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/26.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "AttackType.h"
#import "BattleSprite.h"

@implementation AttackType
@synthesize battleSprite, attackPointArray,attackRange;

-(id)initWithSprite:(BattleSprite*) sprite
{
    if( (self=[super init]) ) {
        battleSprite=sprite;
        [self setParameter];
        
    
    }
    
    return self;
}

-(void)setParameter {
    [self doesNotRecognizeSelector:_cmd];
}

-(void)setPath
{
    attackRange = CGPathCreateMutable();
    CGPoint loc=[[attackPointArray objectAtIndex:0] CGPointValue];
    CGPathMoveToPoint(attackRange, NULL, loc.x, loc.y);
    for (int i=1; i<[attackPointArray count]; i++) {
        CGPoint loc=[[attackPointArray objectAtIndex:i] CGPointValue];
        CGPathAddLineToPoint(attackRange, NULL, loc.x, loc.y);
    }
    
    CGPathCloseSubpath(attackRange);
    CGPathRetain(attackRange);
}

-(NSMutableArray *) getEffectTargets:(NSMutableArray *)enemies
{
    NSMutableArray *effectTargets=   [[NSMutableArray alloc] init];
    for(int i = 0; i<[enemies count];i++)
    {
        BattleSprite *bs = ((BattleSprite*)[enemies objectAtIndex:i]);
    
        ///determine if this attack can effect self
        if([bs getName]==[battleSprite getName])
            continue;
        ///determine if can effect ally
        if(bs.player==battleSprite.player)
            continue;
        
        NSMutableArray *points=bs.pointArray;
        for (int j=0; j<[points count]; j++) {
            CGPoint loc=[[points objectAtIndex:j] CGPointValue];
            // switch coordinate systems
            loc=[bs convertToWorldSpace:loc];
            loc=[battleSprite convertToNodeSpace:loc];
            if (CGPathContainsPoint(attackRange, NULL, loc, NO)) {
                [effectTargets addObject:bs];
                CCLOG(@"Player %d is under attack", bs.player);
                break;
            }
        }
    
        
    }
    return effectTargets;
}


- (void) dealloc
{
    CGPathRelease(attackRange);
	[super dealloc];
}

@end
