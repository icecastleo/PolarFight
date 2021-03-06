//
//  MoveSystem.m
//  MonsterWars
//
//  Created by Ray Wenderlich on 10/27/12.
//  Copyright (c) 2012 Razeware LLC. All rights reserved.
//

#import "MoveSystem.h"
#import "MoveComponent.h"
#import "RenderComponent.h"
#import "AnimationComponent.h"
#import "DirectionComponent.h"
#import "KnockOutComponent.h"
#import "DefenderComponent.h"
#import "spine-cocos2d-iphone.h"
#import "LineComponent.h"
#import "ThreeLineMapLayer.h"

@implementation MoveSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        NSAssert(entityFactory.mapLayer, @"This system need a map layer!");
    }
    return self;
}

-(void)update:(float)delta {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfName:[MoveComponent name]];
    
    for (Entity *entity in entities) {
        
        MoveComponent *move = (MoveComponent *)[entity getComponentOfName:[MoveComponent name]];
        RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        
        KnockOutComponent *knockOutCom = (KnockOutComponent *)[entity getComponentOfName:[KnockOutComponent name]];
        
        // FIXME: KnockOut can't move
        if (knockOutCom) {
            DefenderComponent *defendCom = (DefenderComponent *)[entity getComponentOfName:[DefenderComponent name]];
            float defense = MAX(1, defendCom.defense.value);
            [self knockOut:knockOutCom defense:defense];
            [entity removeComponent:[KnockOutComponent name]];
        }
        
        if (!move || !render)
            continue;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"kEventIsMoveForbidden"];
        [entity sendEvent:kEventIsMoveForbidden Message:dic];
        
        NSNumber *result = [dic objectForKey:@"kEventIsMoveForbidden"];
        
        if (result.boolValue == YES) {
            AnimationComponent *animation = (AnimationComponent *)[entity getComponentOfName:[AnimationComponent name]];
            
            if (animation && animation.state == kAnimationStateMove) {
                [render stopAnimation];
                animation.state = kAnimationStateNone;
            }
            continue;
        }
        
        DirectionComponent *direction = (DirectionComponent *)[entity getComponentOfName:[DirectionComponent name]];
        
        if (direction) {
            Direction oldDirection = direction.direction;
            direction.velocity = move.velocity;
            Direction newDirection = direction.direction;
            
            if (oldDirection != newDirection) {
                [render flip:newDirection];
            }
        }
        
        [self.entityFactory.mapLayer moveEntity:entity byPosition:ccpMult(move.velocity, move.speed.value * kMoveMultiplier * delta) boundaryLimit:YES];
        
        // Run animation
        AnimationComponent *animation = (AnimationComponent *)[entity getComponentOfName:[AnimationComponent name]];
       
        if (!animation) {
            continue;
        }
        
        if (move.velocity.x == 0 && move.velocity.y == 0) {
            if (animation.state == kAnimationStateMove) {
                [render stopAnimation];
                animation.state = kAnimationStateNone;
            }
            
            if (animation.state == kAnimationStateNone) {
                CCAnimation *idel = [animation.animations objectForKey:@"idel"];
                
                if (idel) {
                    CCAction *action = [CCRepeatForever actionWithAction:
                                        [CCAnimate actionWithAnimation:idel]];
                    action.tag = kAnimationActionTag;
                    
                    if (render.isSpineNode) {
                        CCSkeletonAnimation* animationNode = (CCSkeletonAnimation* )render.sprite;
                        [animationNode clearAnimation];
                    } else {
                        [render.sprite runAction:action];
                    }
                    
                    animation.state = kAnimationStateIdel;
                }
            }
        } else {
            if (animation.state == kAnimationStateIdel) {
                [render stopAnimation];
                animation.state = kAnimationStateNone;
            }
            
            if (animation.state == kAnimationStateNone) {
                if (render.isSpineNode) {
                    CCSkeletonAnimation* animationNode = (CCSkeletonAnimation* )render.sprite;
                    
                    if ([animationNode hasAnimation:@"walk"]) {
                        [animationNode setAnimation:@"walk" loop:YES];
                        animation.state = kAnimationStateMove;
                    }
                } else {
                    CCAnimation *moveAnimation = [animation.animations objectForKey:@"move"];
                    if (moveAnimation) {
                        CCAction *action = [CCRepeatForever actionWithAction:
                                            [CCAnimate actionWithAnimation:moveAnimation]];
                        action.tag = kAnimationActionTag;
                        [render.sprite runAction:action];
                        
                        animation.state = kAnimationStateMove;
                    }
                }
            }
        }
    }
}

-(void)knockOut:(KnockOutComponent *)component defense:(float)defense {
    DirectionComponent *directionCom = (DirectionComponent *)[component.entity getComponentOfName:[DirectionComponent name]];
    
    if (!directionCom) {
        return;
    }
    int direction = -1 * directionCom.velocity.x;
    
    // set distance = attack/defense
    float distance = component.attack/defense;
    
    [self.entityFactory.mapLayer knockOutEntity:component.entity byPosition:ccp(direction*distance,0) boundaryLimit:YES];
}

@end
