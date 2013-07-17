//
//  MaskComponent.m
//  CastleFight
//
//  Created by  DAN on 13/7/4.
//
//

#import "MaskComponent.h"
#import "cocos2d.h"
#import "RenderComponent.h"

@interface MaskComponent()
@property (readonly) CCSprite *mask;
@property (readonly) CCProgressTimer *timer;
@end

@implementation MaskComponent

-(id)initWithRenderComponent:(RenderComponent *)renderCom {
    if (self = [super init]) {
        _mask = [CCSprite spriteWithSpriteFrameName:@"bg_user_button.png"];
        _mask.visible = YES;
        [renderCom.node addChild:_mask];
        
        _timer = [[CCProgressTimer alloc] initWithSprite:[CCSprite spriteWithSpriteFrameName:@"bg_user_button.png"]];
        _timer.type = kCCProgressTimerTypeRadial;
        _timer.reverseDirection = YES;
        _timer.percentage = 0;
        [renderCom.node addChild:_timer];
    }
    return self;
}

-(void)receiveEvent:(EntityEvent)type Message:(id)message {
    if (type == kEventUseMask) {
        [self active:[message floatValue]];
    } else if(type == kEventCancelMask) {
        self.mask.visible = NO;
    }
}

-(void)active:(float)time {
    self.mask.visible = YES;
    
    if (time <= 0) {
        return;
    }
    
    CCSequence *sequence = [CCSequence actions:[CCProgressFromTo actionWithDuration:time from:100 to:0],[CCCallBlock actionWithBlock:^{
        self.mask.visible = NO;
    }], nil];
    
    [self.timer runAction:sequence];
}

@end
