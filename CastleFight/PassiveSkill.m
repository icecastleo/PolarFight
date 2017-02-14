//
//  PassiveSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/29.
//
//

#import "PassiveSkill.h"
#import "RenderComponent.h"
#import "AnimationComponent.h"
#import "DirectionComponent.h"

@implementation PassiveSkill

-(id)init {
    if (self = [super init]) {
        _animationKey = @"passiveSkill";
        _totalTime = 0;
    }
    return self;
}

-(void)setOwner:(Entity *)owner {
    _owner = owner;
    
    if (range) {
        range.owner = owner;
    }
}

-(void)active {
    RenderComponent *render = (RenderComponent *)[_owner getComponentOfName:[RenderComponent name]];
    NSAssert(render, @"You can't active skill without render component currently!");
    
    //    state = kCharacterStateUseSkill;
    
    if (!_animationKey) {
        [self activeEffect];
        //        [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_cat.caf"];
    } else {
        AnimationComponent *animationCom = (AnimationComponent *)[_owner getComponentOfName:[AnimationComponent name]];
        
        CCAnimation *animation = [animationCom.animations objectForKey:_animationKey];
        
        if (animation) {
            [render stopAnimation];
            
            _isAnimationFinish = NO;
            
            animationCom.state = kAnimationStateAttack;
            
            CCSequence *attack = [CCSequence actions:
                                  [CCDelayTime actionWithDuration:(animation.totalDelayUnits - 1)*animation.delayPerUnit],
                                  [CCCallFunc actionWithTarget:self selector:@selector(activeEffect)],
                                  nil];
            
            CCSequence *animate = [CCSequence actions:
                                   [CCAnimate actionWithAnimation:animation],
                                   [CCCallBlock actionWithBlock:^{
                _isAnimationFinish = YES;
                animationCom.state = kAnimationStateNone;
            }], nil];
            
            CCAction *action = [CCSpawn actions:attack, animate, nil];
            
            action.tag = kAnimationActionTag;
            [render.sprite runAction:action];
            
//            [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_cat.caf"];
            
            //FIXME: spine animation doesnot work.
        }
    }

}

-(void)activeEffect {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

-(void)checkEvent:(EntityEvent)eventType  Message:(id)message {
    
}

-(BOOL)checkRange {
    return [range getEffectEntities].count > 0;
}

@end
