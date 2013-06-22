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

@implementation MoveSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory mapLayer:(MapLayer *)map {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        _map = map;
    }
    return self;
}

-(void)update:(float)delta {
    NSArray *entities = [self.entityManager getAllEntitiesPosessingComponentOfClass:[MoveComponent class]];
    
    for (Entity *entity in entities) {
        
        MoveComponent *move = (MoveComponent *)[entity getComponentOfClass:[MoveComponent class]];
        RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
        KnockOutComponent *knockOutCom = (KnockOutComponent *)[entity getComponentOfClass:[KnockOutComponent class]];
        
        if (knockOutCom) {
            DefenderComponent *defendCom = (DefenderComponent *)[entity getComponentOfClass:[DefenderComponent class]];
            float defense = MAX(1, defendCom.defense.value);
            [self knockOut:knockOutCom defense:defense];
            [entity removeComponent:[KnockOutComponent class]];
        }
        
        if (!move || !render)
            continue;
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"kEventIsMoveForbidden"];
        [entity sendEvent:kEventIsMoveForbidden Message:dic];
        
        NSNumber *result = [dic objectForKey:@"kEventIsMoveForbidden"];
        
        if (result.boolValue == YES) {
            AnimationComponent *animation = (AnimationComponent *)[entity getComponentOfClass:[AnimationComponent class]];
            
            if (animation && animation.state == kAnimationStateMove) {
                [render.sprite stopActionByTag:kAnimationActionTag];
                animation.state = kAnimationStateNone;
            }
            continue;
        }
        
        DirectionComponent *direction = (DirectionComponent *)[entity getComponentOfClass:[DirectionComponent class]];
        
        if (direction) {
            direction.velocity = move.velocity;
        }

        // FIXME: user hero == yes, other == no;
        [_map moveEntity:entity byPosition:ccpMult(move.velocity, move.speed.value * kMoveMultiplier * delta) boundaryLimit:YES];
        
        // Run animation
        AnimationComponent *animation = (AnimationComponent *)[entity getComponentOfClass:[AnimationComponent class]];
       
        if (!animation) {
            continue;
        }
        
        if (move.velocity.x == 0 && move.velocity.y == 0) {
            if (animation.state == kAnimationStateMove) {
                [render.sprite stopActionByTag:kAnimationActionTag];
                animation.state = kAnimationStateNone;
            }
            
            if (animation.state == kAnimationStateNone) {
                CCAnimation *idel = [animation.animations objectForKey:@"idel"];
                
                if (idel) {
                    CCAction *action = [CCRepeatForever actionWithAction:
                                        [CCAnimate actionWithAnimation:idel]];
                    action.tag = kAnimationActionTag;
                    [render.sprite runAction:action];
                    
                    animation.state = kAnimationStateIdel;
                }
            }
        } else {
            if (animation.state == kAnimationStateIdel) {
                [render.sprite stopActionByTag:kAnimationActionTag];
                animation.state = kAnimationStateNone;
            }
            
            if (animation.state == kAnimationStateNone) {
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

-(void)knockOut:(KnockOutComponent *)component defense:(float)defense {
    DirectionComponent *directionCom = (DirectionComponent *)[component.entity getComponentOfClass:[DirectionComponent class]];
    
    if (!directionCom) {
        return;
    }
    int direction = -1 * directionCom.velocity.x;
    
    // set distance = attack/defense
    float distance = component.attack/defense;
    
    [_map knockOutEntity:component.entity byPosition:ccp(direction*distance,0) boundaryLimit:YES];
}

@end
