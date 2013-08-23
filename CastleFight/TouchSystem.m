//
//  TouchSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/8/22.
//
//

#import "TouchSystem.h"
#import "TouchComponent.h"
#import "RenderComponent.h"

@interface TouchSystem() {
    Entity *touchedEntity;
    BOOL isBegan;
    BOOL isPan;
    NSMutableArray *panPath;
    
    __weak Entity *selectedEntity;
}

@end

@implementation TouchSystem

-(id)initWithEntityManager:(EntityManager *)entityManager entityFactory:(EntityFactory *)entityFactory {
    if (self = [super initWithEntityManager:entityManager entityFactory:entityFactory]) {
        panPath = [[NSMutableArray alloc] init];
    }
    return self;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (isBegan) {
        return NO;
    }
    
    // Prevent two touch
    isBegan = YES;
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    NSArray *array = [self.entityManager getAllEntitiesPosessingComponentOfName:[TouchComponent name]];
    
    // TODO: Sort entities by render's y position!
    for (Entity *entity in array) {
        RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        TouchComponent *touchCom = (TouchComponent *)[entity getComponentOfName:[TouchComponent name]];
        
        if (touchCom.touchable && CGRectContainsPoint(render.sprite.boundingBox, [render.sprite.parent convertToNodeSpace:touchLocation])) {
            touchedEntity = entity;
            break;
        }
    }
        
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    if (isPan == NO) {
        isPan = YES;
    }
    
    if (touchedEntity == nil) {
        // TODO: Move map here!
        return;
    }
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if (touchedEntity) {
        if (touchedEntity == selectedEntity) {
            // Maybe we can move the selected entity!
        } else {
            [panPath addObject:[NSValue valueWithCGPoint:touchLocation]];
            
            TouchComponent *touchCom = (TouchComponent *)[touchedEntity getComponentOfName:[TouchComponent name]];
            
            if ([touchCom.delegate respondsToSelector:@selector(drawPan:)]) {
                [touchCom.delegate drawPan:panPath];
            }
        }
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    if (isPan && touchedEntity) {
        TouchComponent *touchCom = (TouchComponent *)[touchedEntity getComponentOfName:[TouchComponent name]];
        
        if ([touchCom.delegate respondsToSelector:@selector(handlePan:)]) {
            [touchCom.delegate handlePan:panPath];
        }
    } else if (touchedEntity == nil) {
        // User doesn't touch anything!
        // Cancel selected entity or do something on selected entity !
        
//        if (selectedEntity != nil) {
//            TouchComponent *selectedEntityTouch = (TouchComponent *)[selectedEntity getComponentOfName:[TouchComponent name]];
//            
//            if ([selectedEntityTouch.delegate respondsToSelector:@selector(handleUnselect)]) {
//                [selectedEntityTouch.delegate handleUnselect];
//            }
//            selectedEntity = nil;
//        }
    } else {
        // User definitely touched something!
        
        TouchComponent *touchCom = (TouchComponent *)[touchedEntity getComponentOfName:[TouchComponent name]];

        if (touchCom.canSelect) {
            // Cancle previous select
            if (selectedEntity != nil) {
                TouchComponent *selectedEntityTouch = (TouchComponent *)[selectedEntity getComponentOfName:[TouchComponent name]];
                
                if ([selectedEntityTouch.delegate respondsToSelector:@selector(handleUnselect)]) {
                    [selectedEntityTouch.delegate handleUnselect];
                }
            }
            
            if (touchedEntity == selectedEntity) {
                selectedEntity = nil;
            } else {
                // Select new entity! 
                selectedEntity = touchedEntity;
                
                if ([touchCom.delegate respondsToSelector:@selector(handleSelect:)]) {
                    [touchCom.delegate handleSelect];
                }
            }
        } else {
            // Tap entity
            if ([touchCom.delegate respondsToSelector:@selector(handleTap:)]) {
                [touchCom.delegate handleTap];
            }
        }
    }
    isBegan = NO;
    isPan = NO;
    touchedEntity = nil;
    panPath = [[NSMutableArray alloc] init];
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    isBegan = NO;
    isPan = NO;
    touchedEntity = nil;
    panPath = [[NSMutableArray alloc] init];
}


@end
