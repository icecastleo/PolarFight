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
            [self.entityFactory.mapLayer addChild:event.range.rangeSprite z:self.entityFactory.mapLayer.maxChildZ];

            [self projectEvent:event];
        }
        
        [projectingEvents addObjectsFromArray:projectile.projectileEventQueue];
        [projectile.projectileEventQueue removeAllObjects];
    }
    
    for (ProjectileEvent *event in projectingEvents) {
        [self updateEvent:event];
    }
    
    for (ProjectileEvent *event in finishEvents) {
        [event.range.rangeSprite stopAllActions];
        [projectingEvents removeObjectsInArray:finishEvents];
    }
    
    [finishEvents removeAllObjects];
}

-(void)projectEvent:(ProjectileEvent *)event {
    if (event.type == kProjectileTypeLine) {
        
    } else if (event.type == kProjectileTypeParabola) {
        [self parabolaProject:event];
    } else {
        NSAssert(NO, @"Invalid type");
    }
}

-(void)lineProject:(ProjectileEvent *)event {
    event.range.rangeSprite.position = event.startPosition;
    [event.range setDirection:ccpSub(event.endPosition, event.startPosition)];
        
    CCAction *action = [CCSequence actions:
                        [CCMoveTo actionWithDuration:event.time position:event.endPosition],
                        [self finishAction:event],
                        nil];
    
    [event.range.rangeSprite runAction:action];
}

-(void)parabolaProject:(ProjectileEvent *)event {
    event.range.rangeSprite.position = event.startPosition;
    
    CGFloat startAngle = event.startPosition.x > event.endPosition.x ? 135 : 45;
    CGFloat endAngle = event.startPosition.x > event.endPosition.x ? 225 : 315;
    
    float sx = event.startPosition.x;
    float sy = event.startPosition.y;
    float ex = event.endPosition.x;
    float ey = event.endPosition.y;
    
    startAngle = 270 - startAngle;
    endAngle = 270 - endAngle;
    
    event.range.rangeSprite.rotation = startAngle;
    
    ccBezierConfig bezier;
    bezier.controlPoint_1 = event.startPosition; // start point
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5 + 125); // control point
    bezier.endPosition = event.endPosition; // end point
    
    CCBezierTo *actionMove = [CCBezierTo actionWithDuration:event.time bezier:bezier];
    CCRotateTo *actionRotate =[CCRotateTo actionWithDuration:event.time angle:endAngle];
    
    CCAction *action = [CCSequence actions:
                        [CCSpawn actions:actionMove, actionRotate, nil],
                        [self finishAction:event],
                        nil];
                            
    [event.range.rangeSprite runAction:action];
}

-(CCAction *)finishAction:(ProjectileEvent *)event {
    return [CCCallBlock actionWithBlock:^{
        [finishEvents addObject:event];
    }];
}

-(void)updateEvent:(ProjectileEvent *)event {
    NSArray *entities = [event.range getEffectEntities];
    
    if(entities.count > 0) {
        event.block(entities, event.range.effectPosition);
        
        if (!event.isPiercing) {
            [finishEvents addObject:event];
        }
    };
}

@end