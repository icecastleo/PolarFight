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

-(id)initWithRange:(Range *)aRange delegateSkill:(DelegateSkill *)aDelegate{
    if (self = [super init]) {
        range = aRange;
        delegate = aDelegate;
        [range.character.sprite.parent addChild:range.rangeSprite];
    }
    return self;
}

-(void)shootFrom:(CGPoint)start toPosition:(CGPoint)end speed:(float)aSpeed {
//    CCLOG(@"shoot");
    startPosition = start;
    range.rangeSprite.position = start;
    endPosition = end;
    speed = aSpeed;
    vector = ccpNormalize(ccpSub(end, start));
    
    t = ccpDistance(start, end) / speed;

    float angle = atan2f(vector.y, vector.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angle);
    float cocosAngle = 270 - angleDegrees;
    
    range.rangeSprite.rotation = cocosAngle;
    
    [self scheduleUpdate];
    
    [[BattleController currentInstance] addChild:self];
}

-(void)update:(ccTime)delta {
    t -= delta;
    
    if(t < 0) {
        range.rangeSprite.position = endPosition;
    } else {
        range.rangeSprite.position = ccpAdd(range.rangeSprite.position, ccpMult(vector, speed));
    }
    
    NSArray *effectTargets = [range getEffectTargets];
    
    if(effectTargets.count > 0) {
        if ([delegate respondsToSelector:@selector(effectTarget:atPosition:)]) {
            for (Character *target in effectTargets) {
                [delegate effectTarget:target atPosition:range.effectPosition];
            }
            [self unschedule:@selector(update:)];
            [self removeFromParentAndCleanup:YES];
        }
    };
    
    if(t < 0) {
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
        return;
    }
}

@end
