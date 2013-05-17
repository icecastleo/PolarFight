//
//  RangeShooter.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/16.
//
//

#import "RangeShooterNew.h"
#import "Character.h"
#import "BattleController.h"

@implementation RangeShooterNew

-(id)initWithRange:(Range *)aRange block:(void (^)())aBlock {
    if (self = [super init]) {
        range = aRange;
        block = aBlock;
        [range.character.sprite.parent addChild:range.rangeSprite];
    }
    return self;
}

//-(id)initWithRange:(Range *)aRange delegateSkill:(DelegateSkill *)aDelegate{
//    if (self = [super init]) {
//        range = aRange;
//        delegate = aDelegate;
//        [range.character.sprite.parent addChild:range.rangeSprite];
//    }
//    return self;
//}

-(void)shoot:(CGPoint)aTargetPoint time:(float)aTime {
    //    CCLOG(@"shoot");
    targetPoint = aTargetPoint;
    time = aTime;
    
    range.rangeSprite.position = ccpAdd(range.character.boundingBox.origin, ccp(aTargetPoint.x >= range.character.position.x ? range.character.boundingBox.size.width : 0, range.character.boundingBox.size.height / 4 * 3));

    CGFloat startA = aTargetPoint.x >= range.character.position.x ? 45 : 135;
    CGFloat endA = aTargetPoint.x >= range.character.position.x ? 315 : 225;
        
    [self moveWithParabola:range.rangeSprite startP:range.rangeSprite.position endP:aTargetPoint startA:startA endA:endA];
    
    [self scheduleUpdate];
    
    [[BattleController currentInstance] addChild:self];
}

-(void)update:(ccTime)delta
{
    if(ccpDistance(range.rangeSprite.position, targetPoint) == 0)
    {
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
        return;
    }
    
    NSArray *effectTargets = [range getEffectEntities];
    
    if(effectTargets.count > 0) {
        if ([delegate respondsToSelector:@selector(effectTarget:atPosition:)]) {
            for (Character *target in effectTargets) {
                [delegate effectTarget:target atPosition:range.effectPosition];
            }
            [self unschedule:@selector(update:)];
            [self removeFromParentAndCleanup:YES];
        }
    };
}

-(void)moveWithParabola:(CCSprite*)sprite startP:(CGPoint)startPoint endP:(CGPoint)endPoint startA:(float)startAngle endA:(float)endAngle {
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex = endPoint.x;
    float ey = endPoint.y;
    
    startAngle = 270 - startAngle;
    endAngle = 270 - endAngle;
    
    sprite.rotation = startAngle;
    
    ccBezierConfig bezier;
    bezier.controlPoint_1 = ccp(sx, sy); // start point
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5 + 125); // control point
    bezier.endPosition = ccp(endPoint.x, endPoint.y); // end point
    
    CCBezierTo *actionMove = [CCBezierTo actionWithDuration:time bezier:bezier];
    CCRotateTo *actionRotate =[CCRotateTo actionWithDuration:time angle:endAngle];
    CCAction * action = [CCSpawn actions:actionMove, actionRotate, nil];
    
    [sprite runAction:action];
}
@end
