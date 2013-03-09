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

-(id)initWithRange:(Range *)aRange {
    if (self = [super init]) {
        range = aRange;
    }
    return self;
}

-(void)shoot:(CGPoint)aTargetPoint time:(float)aTime delegate:(id<RangeShooterNewDelegate>)aDelegate {
    //    CCLOG(@"shoot");
    delegate = aDelegate;
    targetPoint = aTargetPoint;
    time = aTime;
    
    if (range.rangeSprite.parent != nil) {
        [range.rangeSprite removeFromParentAndCleanup:NO];
    }
    
    range.rangeSprite.position = range.character.position;
    [range.character.sprite.parent addChild:range.rangeSprite];
       range.rangeSprite.visible = YES;
    CGFloat endA = aTargetPoint.x>=range.rangeSprite.position.x?359:1;
        
    [self moveWithParabola:range.rangeSprite startP:range.rangeSprite.position endP:aTargetPoint startA:180 endA:endA];
    
  
    [self scheduleUpdate];
    
    [[BattleController currentInstance] addChild:self];
}

-(void)update:(ccTime)delta
{
  
    if(ccpDistance(range.rangeSprite.position, targetPoint) < 15)
    {
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
        return;
    }
    
    NSArray *effectTargets = [range getEffectTargets];
    
    if(effectTargets.count > 0) {
        if ([delegate respondsToSelector:@selector(delayExecute:)]) {
            [delegate delayExecute:effectTargets effectPosition:range.effectPosition];
        }
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
    };
}
- (void) moveWithParabola:(CCSprite*)mSprite startP:(CGPoint)aStartPoint endP:(CGPoint)endPoint startA:(float)startAngle endA:(float)endAngle {
    float sx = aStartPoint.x;
    float sy = aStartPoint.y;
    float ex =endPoint.x+50;
    float ey =endPoint.y+150;
    //设置精灵的起始角度
    mSprite.rotation=startAngle;
    ccBezierConfig bezier; // 创建贝塞尔曲线
    bezier.controlPoint_1 = ccp(sx, sy); // 起始点
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200); //控制点
    bezier.endPosition = ccp(endPoint.x, endPoint.y); // 结束位置
    CCBezierTo *actionMove = [CCBezierTo actionWithDuration:time bezier:bezier];
    //创建精灵旋转的动作
    CCRotateTo *actionRotate =[CCRotateTo actionWithDuration:time angle:endAngle];

    //将两个动作封装成一个同时播放进行的动作
    CCAction * action = [CCSpawn actions:actionMove, actionRotate, nil];
    [mSprite runAction:action];
}
@end
