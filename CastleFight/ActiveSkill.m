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
#import "DirectionComponent.h"

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
    _owner = owner;
    
    if (range) {
        range.owner = owner;
        
//        CCSprite *rangeSprite = range.rangeSprite;
//        
//        if (rangeSprite) {
//            NSAssert(rangeSprite.parent == nil, @"Do you set the owner twice?");
//            
//            RenderComponent *render = (RenderComponent *)[owner getComponentOfClass:[RenderComponent class]];
//            NSAssert(render, @"You can't set an eitity without RenderComponent as owner!");
//            
//            // Not needed for circle range
////            NSAssert([owner getComponentOfClass:[DirectionComponent class]], @"You can't set an eitity without DirectionComponent as owner!");
//            
//            rangeSprite.visible = NO;
//            [render.node addChild:rangeSprite z:-5];
//        }
    }
}

-(void)active {
    RenderComponent *render = (RenderComponent *)[_owner getComponentOfClass:[RenderComponent class]];
    NSAssert(render, @"You can't active skill without render component currently!");
    
//    state = kCharacterStateUseSkill;
    
    if (_cooldown != 0) {
        _canActive = NO;
        
        [render.node runAction:
         [CCSequence actions:
          [CCDelayTime actionWithDuration:_cooldown],
          [CCCallBlock actionWithBlock:^{
             _canActive = YES;
         }], nil]];
    }
    
    if (_animationKey) {
        AnimationComponent *animationCom = (AnimationComponent *)[_owner getComponentOfClass:[AnimationComponent class]];
        
        CCAnimation *animation = [animationCom.animations objectForKey:_animationKey];
        
        if (animation) {
            [render.sprite stopActionByTag:kAnimationActionTag];
                        
            animationCom.state = kAnimationStateAttack;
            
            CCAnimationFrame *frame = [animation.frames lastObject];
            
            CCSequence *attack = [CCSequence actions:
                                  [CCDelayTime actionWithDuration:(animation.totalDelayUnits - frame.delayUnits) * animation.delayPerUnit],
                                  [CCCallFunc actionWithTarget:self selector:@selector(activeEffect)],
                                  nil];
            
            CCSequence *animate = [CCSequence actions:
                                   [CCAnimate actionWithAnimation:animation],
                                   [CCCallBlock actionWithBlock:^{
                _isFinish = YES;
                animationCom.state = kAnimationStateNone;
            }], nil];
            
            CCAction *action = [CCSpawn actions:attack, animate, nil];
            
            action.tag = kAnimationActionTag;
            [render.sprite runAction:action];
            
//            [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_cat.caf"];
            return;
        }
    }
    
    [self activeEffect];
    _isFinish = YES;
//    [[SimpleAudioEngine sharedEngine] playEffect:@"sound_caf/effect_die_cat.caf"];
}

-(void)activeEffect {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

-(BOOL)checkRange {
    return [range getEffectEntities].count > 0;
}

@end
