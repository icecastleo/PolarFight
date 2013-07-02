//
//  ProjectileSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/5/18.
//
//

#import "ProjectileSystem.h"
#import "ProjectileComponent.h"
#import "ProjectileEvent.h"

@implementation ProjectileSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    NSAssert(entityFactory.mapLayer, @"We need a map to projectile");
    
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        projectingEvents = [[NSMutableArray alloc] init];
        finishEvents = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)update:(float)delta {
    
    for (Entity *entity in [self.entityManager getAllEntitiesPosessingComponentOfClass:[ProjectileComponent class]]) {
        ProjectileComponent *projectile = (ProjectileComponent *)[entity getComponentOfClass:[ProjectileComponent class]];
        
        for (ProjectileEvent *event in projectile.projectileEventQueue) {
            event.range.owner = entity;
            // Add projectile range to map!
            [self.entityFactory.mapLayer addChild:event.range.rangeSprite z:self.entityFactory.mapLayer.maxChildZ];

            [self projectEvent:event];
        }
        
        [projectingEvents addObjectsFromArray:projectile.projectileEventQueue];
        [projectile.projectileEventQueue removeAllObjects];
    }
    
    for (ProjectileEvent *event in projectingEvents) {
        if (!event.isFinish) {
            [self updateEvent:event];
        }
    }
    
    for (ProjectileEvent *event in finishEvents) {
        [event.range.rangeSprite stopAllActions];
        [projectingEvents removeObjectsInArray:finishEvents];
    }
    
    [finishEvents removeAllObjects];
}

-(void)projectEvent:(ProjectileEvent *)event {
    event.range.rangeSprite.position = [event.range.rangeSprite.parent convertToNodeSpace:event.startWorldPosition];
    
    if (event.type == kProjectileTypeLine) {
        [self lineProject:event];
    } else if (event.type == kProjectileTypeParabola) {
        [self parabolaProject:event];
    } else {
        NSAssert(NO, @"Invalid type");
    }
}

#pragma mark - Project formula

-(void)lineProject:(ProjectileEvent *)event {
    event.range.rangeSprite.position = event.startPosition;
    [event.range setDirection:ccpSub(event.endPosition, event.startPosition)];
    
    CCAction *action = [CCSequence actions:
                        [CCSpawn actions:[CCMoveTo actionWithDuration:event.time position:event.endPosition], event.middleAction, nil]
                        ,
                        [self finishAction:event],
                        nil];

    
    [event.range.rangeSprite runAction:action];
}

-(void)parabolaProject:(ProjectileEvent *)event {
    float sx = event.startWorldPosition.x;
    float sy = event.startWorldPosition.y;
    float ex = event.endWorldPosition.x;
    float ey = event.endWorldPosition.y;
    
    int height = (ex-sx)/2 + (ey-sy)/2;
    
    CCJumpBy *actionMove = [CCJumpBy actionWithDuration:event.time position:ccpSub(event.endWorldPosition, event.startWorldPosition) height:height jumps:1];
    
    CGFloat startAngle = event.startWorldPosition.x > event.endWorldPosition.x ? 135 : 45;
    CGFloat endAngle = event.startWorldPosition.x > event.endWorldPosition.x ? 225 : 315;
    
    startAngle = 270 - startAngle;
    endAngle = 270 - endAngle;
    
    event.range.rangeSprite.rotation = startAngle;
    
    CCRotateTo *actionRotate =[CCRotateTo actionWithDuration:event.time angle:endAngle];
    
    CCAction *action = [CCSequence actions:
                        [CCSpawn actions:actionMove, actionRotate, event.middleAction, nil],
                        [self finishAction:event],
                        nil];
                            
    [event.range.rangeSprite runAction:action];
}

-(CCAction *)finishAction:(ProjectileEvent *)event {
    CCAction *action;
    CCAction *callBack = [CCCallBlock actionWithBlock:^{
        [finishEvents addObject:event];
    }];
    
    if(event.finishAction){
        action = [CCSequence actions:event.finishAction,callBack,nil];;
    }else {
        action = callBack;
    }
    
    return action;
}

-(void)updateEvent:(ProjectileEvent *)event {
    NSArray *entities = [event.range getEffectEntities];
    
    if(entities.count > 0) {
        event.block(entities, event.range.effectPosition);
        if (!event.isPiercing) {
            [event.range.rangeSprite stopAllActions];
            event.isFinish = YES;
            [event.range.rangeSprite runAction:[self finishAction:event]];
        }
    };
}

@end
