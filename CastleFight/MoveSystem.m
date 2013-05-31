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

        if (!move || !render)
            continue;
        
        NSMutableDictionary *testDic = [NSMutableDictionary new];
        [testDic setObject:[NSNumber numberWithBool:NO] forKey:@"kEventIsMoveForbidden"];
        [entity sendEvent:kEventIsMoveForbidden Message:testDic];
        
        NSNumber *result = [testDic objectForKey:@"kEventIsMoveForbidden"];
        
        if (result.boolValue == YES) {
            continue;
        }
        
        DirectionComponent *direction = (DirectionComponent *)[entity getComponentOfClass:[DirectionComponent class]];
        
        if (direction) {
            direction.velocity = move.velocity;
        }

        // FIXME: user hero == yes, other == no;
        [_map moveEntity:entity byPosition:ccpMult(move.velocity, move.speed.value * kMoveMultiplier * delta) boundaryLimit:YES];
        
        // Run dead animation
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

@end
