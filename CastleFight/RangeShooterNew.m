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

-(id)initWithRange:(Range *)aRange delegateSkill:(DelegateSkill *)aDelegate{
    if (self = [super init]) {
        range = aRange;
        delegate = aDelegate;
        [range.character.sprite.parent addChild:range.rangeSprite];
    }
    return self;
}

-(void)shoot:(CGPoint)aTargetPoint time:(float)aTime {
    //    CCLOG(@"shoot");
    targetPoint = aTargetPoint;
    time = aTime;
    
    range.rangeSprite.position =ccpAdd(range.character.position,ccp(0,range.character.boundingBox.size.height/2));

    CGFloat endA = aTargetPoint.x >= range.rangeSprite.position.x?300:60;
        
    [self moveWithParabola:range.rangeSprite startP:range.rangeSprite.position endP:aTargetPoint startA:180 endA:endA];
    
    [self scheduleUpdate];
    
    [[BattleController currentInstance] addChild:self];
}

-(void)update:(ccTime)delta
{
    if(ccpDistance(range.rangeSprite.position, targetPoint)==0)
    {
        [self unschedule:@selector(update:)];
        [self removeFromParentAndCleanup:YES];
        return;
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
}

-(void)moveWithParabola:(CCSprite*)mSprite startP:(CGPoint)aStartPoint endP:(CGPoint)endPoint startA:(float)startAngle endA:(float)endAngle {
    float sx = aStartPoint.x;
    float sy = aStartPoint.y;
    float ex = endPoint.x ;
    float ey = endPoint.y ;
    //设置精灵的起始角度
    mSprite.rotation = startAngle;
    ccBezierConfig bezier; // 创建贝塞尔曲线
    bezier.controlPoint_1 = ccp(sx, sy); // 起始点
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+100); //控制点
    bezier.endPosition = ccp(endPoint.x, endPoint.y); // 结束位置
    CCBezierTo *actionMove = [CCBezierTo actionWithDuration:time bezier:bezier];
    //创建精灵旋转的动作
    CCRotateTo *actionRotate =[CCRotateTo actionWithDuration:time angle:endAngle];

    //将两个动作封装成一个同时播放进行的动作
    CCAction * action = [CCSpawn actions:actionMove, actionRotate, nil];
    [mSprite runAction:action];
}
@end
