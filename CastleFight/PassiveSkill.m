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
        
        CCSprite *rangeSprite = range.rangeSprite;
        
        if (rangeSprite) {
            NSAssert(rangeSprite.parent == nil, @"Do you set the owner twice?");
            
            RenderComponent *renderCom = (RenderComponent *)[owner getComponentOfClass:[RenderComponent class]];
            NSAssert(renderCom, @"You can't set an eitity without RenderComponent as owner!");
            
            //            NSAssert([owner getComponentOfClass:[DirectionComponent class]], @"You can't set an eitity without DirectionComponent as owner!");
            
            rangeSprite.zOrder = -1;
            rangeSprite.visible = NO;
            rangeSprite.position = ccp(renderCom.sprite.boundingBox.size.width/2, renderCom.sprite.boundingBox.size.height/2);
            [renderCom.sprite addChild:rangeSprite];
        }
    }
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
            [renderCom.sprite stopActionByTag:kAnimationAttackActionTag];
            
            _isAnimationFinish = NO;
            
            animationCom.state = kAnimationStateAttack;
            
            CCAction *action = [CCSequence actions:
                                [CCAnimate actionWithAnimation:animation],
                                [CCCallBlock actionWithBlock:^{
                _isAnimationFinish = YES;
                animationCom.state = kAnimationStateNone;
            }], nil];
            
            action.tag = kAnimationAttackActionTag;
            [renderCom.sprite runAction:action];
        }
    }
}

-(void)activeEffect {
    [NSException raise:NSInternalInconsistencyException
                format:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])];
}

-(void)checkEvent:(EventType)eventType {
    
}

-(BOOL)checkRange {
    // Synchronize direction
    DirectionComponent *direction = (DirectionComponent *)[_owner getComponentOfClass:[DirectionComponent class]];
    
    if (direction) {
        [range setDirection:direction.velocity];
    }
    
    return [range getEffectEntities].count > 0;
}

@end
