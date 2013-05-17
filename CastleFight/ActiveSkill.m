//
//  Skill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/28.
//
//

#import "ActiveSkill.h"
#import "RenderComponent.h"
#import "AnimationComponent.h"
#import "MoveComponent.h"

@implementation ActiveSkill

-(id)init {
    if (self = [super init]) {
//        [self setSkill];
        _combo = [[NSMutableDictionary alloc] initWithCapacity:0];
        _canActive = YES;
        _animationKey = @"attack";
        _cooldown = 3;
    }
    return self;
}

//-(void)setSkill {
//    [NSException raise:NSInternalInconsistencyException
//                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
//}

-(void)setOwner:(Entity *)owner {
    if (range) {
        range.owner = owner;
    }
    _owner = owner;
}

-(void)active {
    RenderComponent *renderCom = (RenderComponent *)[_owner getComponentOfClass:[RenderComponent class]];
    NSAssert(renderCom, @"You can't active skill without render component currently!");
        
    // TODO: Active delay and sound effect
    [self activeEffect];
    //    [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_cat.caf"];
    
//    state = kCharacterStateUseSkill;
    
    if (_animationKey) {
        AnimationComponent *animationCom = (AnimationComponent *)[_owner getComponentOfClass:[AnimationComponent class]];
        
        CCAnimation *animation = [animationCom.animations objectForKey:_animationKey];
        
        if (animation) {
            [renderCom.sprite stopActionByTag:kAnimationActionTag];
            
            _isFinish = NO;
            
            animationCom.state = kAnimationStateAttack;
            
            CCAction *action = [CCSequence actions:
                                [CCAnimate actionWithAnimation:animation],
                                [CCCallBlock actionWithBlock:^{
                _isFinish = YES;
                animationCom.state = kAnimationStateNone;
            }], nil];
            
            action.tag = kAnimationActionTag;
            [renderCom.sprite runAction:action];
        }
    }
    
    if (_cooldown != 0) {
        _canActive = NO;
        
        [renderCom.sprite runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:_cooldown],
          [CCCallBlock actionWithBlock:^{
             _canActive = YES;
         }], nil]];
    }
}

-(void)activeEffect {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

-(BOOL)checkRange {
    return [range getEffectEntities].count > 0;
}

@end
