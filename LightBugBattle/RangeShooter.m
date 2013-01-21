//
//  RangeShooter.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/16.
//
//

#import "RangeShooter.h"
#import "Character.h"

@implementation RangeShooter

-(id)initWithRange:(Range *)aRange {
    if (self = [super init]) {
        range = aRange;
    }
    return self;
}

-(void)shoot:(CGPoint)aVector speed:(float)aSpeed delegate:(id)aDelegate {
    //    NSLog(@"shoot");
    delegate = aDelegate;
    speed = aSpeed;
    
    range.rangeSprite.position = range.character.position;
    [range.character.sprite.parent addChild:range.rangeSprite];
    range.rangeSprite.visible = YES;
    
    float angle = atan2f(vector.y, vector.x);
    float angleDegrees = CC_RADIANS_TO_DEGREES(angle);
    float cocosAngle = -1 * angleDegrees;
    
    range.rangeSprite.rotation = cocosAngle;
    
    startPoint = range.rangeSprite.position;
    [self schedule:@selector(update:)];
}

-(void)update:(ccTime)delta
{
    self.position = ccpAdd(self.position, ccpMult(vector, speed));
    
    if(ccpDistance(self.position, startPoint) > 200)
    {
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
        return;
    }
    
    NSMutableArray *effectTargets = [range getEffectTargets];
    
    if(effectTargets.count > 0) {
        if ([delegate respondsToSelector:@selector(delayExecute:)]) {
            [delegate delayExecute:effectTargets];
        }
        
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
    };
}

@end
