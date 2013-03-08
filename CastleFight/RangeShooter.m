//
//  RangeShooter.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/16.
//
//

#import "RangeShooter.h"
#import "Character.h"
#import "BattleController.h"

@implementation RangeShooter

-(id)initWithRange:(Range *)aRange {
    if (self = [super init]) {
        range = aRange;
    }
    return self;
}

-(void)shoot:(CGPoint)aVector speed:(float)aSpeed delegate:(id<RangeShooterDelegate>)aDelegate {
//    CCLOG(@"shoot");
    delegate = aDelegate;
    vector = aVector;
    speed = aSpeed;
    
    if (range.rangeSprite.parent != nil) {
        [range.rangeSprite removeFromParentAndCleanup:NO];
    }
    
    range.rangeSprite.position = range.character.position;
    [range.character.sprite.parent addChild:range.rangeSprite];
    
    range.rangeSprite.visible = YES;
    
    float angle = atan2f(vector.y, vector.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angle);
    float cocosAngle = 270 - angleDegrees;
    
    range.rangeSprite.rotation = cocosAngle;
    
    startPoint = range.rangeSprite.position;
    [self scheduleUpdate];
    
    [[BattleController currentInstance] addChild:self];
}

-(void)update:(ccTime)delta
{
    range.rangeSprite.position = ccpAdd(range.rangeSprite.position, ccpMult(vector, speed));

    if(ccpDistance(range.rangeSprite.position, startPoint) > 200)
    {
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
        return;
    }
    
    NSArray *effectTargets = [range getEffectTargets];
    
    if(effectTargets.count > 0) {
        if ([delegate respondsToSelector:@selector(delayExecute:effectPosition:)]) {
            [delegate delayExecute:effectTargets effectPosition:range.effectPosition];
        }
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
    };
}

@end
