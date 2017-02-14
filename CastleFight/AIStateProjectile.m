//
//  AIStateProjectile.m
//  CastleFight
//
//  Created by 朱 世光 on 13/7/21.
//
//

#import "AIStateProjectile.h"
#import "RenderComponent.h"

@interface AIStateProjectile() {
    ProjectileEvent *event;
    CCAction *projectileAction;
    
    NSMutableDictionary *piercingEntities;
}

@end

@implementation AIStateProjectile

-(id)initWithProjectEvent:(ProjectileEvent *)pEvent {
    if (self = [super init]) {
        event = pEvent;
        projectileAction = [event createProjectileAction];
        
        if (event.isPiercing) {
            piercingEntities = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

-(void)enter:(Entity *)entity {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    
    if (projectileAction) {
        [render.node runAction:projectileAction];
        
        if (event.startAction) {
            [render.sprite runAction:event.startAction];
        }
    } else if (event.startAction) {
        NSAssert([event.startAction isKindOfClass:[CCFiniteTimeAction class]], @"Illegal action type!");
        [render.sprite runAction:event.startAction];
    }
}

-(void)updateEntity:(Entity *)entity {
    if (projectileAction) {
        if(!event.isPiercing) {
            NSArray *entities = [event.range getEffectEntities];
                        
            if (entities.count != 0) {
                //finish
                if(event.block) {
                    event.block([event.range getEffectEntities], event.range.effectPosition);
                };
                
                [self finishWithEntity:entity];
            }
        } else {
            NSArray *entities = [event.range getEffectEntities];
            
            if (entities.count != 0) {
                NSMutableArray *temp = [[NSMutableArray alloc] init];
                
                for (Entity *entity in entities) {
                    if (![piercingEntities objectForKey:entity.eidNumber]) {
                        [piercingEntities setObject:entity forKey:entity.eidNumber];
                        [temp addObject:entity];
                    }
                }
                
                if(event.block) {
                    event.block(temp, event.range.effectPosition);
                };
            }
        }
        
        if ([projectileAction isDone]) {
            // finish
            [self finishWithEntity:entity];
        }
    } else if (event.startAction) {
        if ([event.startAction isDone]) {
            // finish
            if(event.block) {
                event.block([event.range getEffectEntities], event.range.effectPosition);
            };
            
            [self finishWithEntity:entity];
        }
    } else {
        // finish
        if(event.block) {
            event.block([event.range getEffectEntities], event.range.effectPosition);
        };
        
        [self finishWithEntity:entity];
    }
}

-(void)finishWithEntity:(Entity *)entity {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
    [render.sprite stopAllActions];
    
    [entity removeSelf];
    
    if (event.finishAction) {
        [render.sprite runAction:
         [CCSequence actions:
          event.finishAction,
          [CCCallBlock actionWithBlock:^{
             [render.node removeFromParentAndCleanup:YES];
         }], nil]];
    } else {
        [render.node removeFromParentAndCleanup:YES];
    }
}

@end
