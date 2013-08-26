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
    NSArray *descriptors;
    
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
        
        touchedEntity = nil;
        selectedEntity = nil;
        
#ifdef kTouchSystemSortEntities
        [self initDescriptors];
#endif
    }
    return self;
}

#ifdef kTouchSystemSortEntities
-(void)initDescriptors {
    // Sort entities by render's y position!
    NSSortDescriptor *ySort = [[NSSortDescriptor alloc] initWithKey:nil ascending:NO comparator:^NSComparisonResult(Entity *obj1, Entity *obj2) {
        RenderComponent *render1 = (RenderComponent *)[obj1 getComponentOfName:[RenderComponent name]];
        RenderComponent *render2 = (RenderComponent *)[obj2 getComponentOfName:[RenderComponent name]];
        
        NSAssert(render1 && render2, @"Can't sort entity without render component!");
        
        if (render1.node.zOrder < render2.node.zOrder) {
            return NSOrderedAscending;
        } else if (render1.node.zOrder > render2.node.zOrder) {
            return NSOrderedDescending;
        } else {
            return NSOrderedSame;
        }
    }];
    
    descriptors = [NSArray arrayWithObjects:ySort, nil];
}
#endif

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    if (isBegan) {
        return NO;
    }
    
    // Prevent two touch
    isBegan = YES;
    
    // Reset variable
    isPan = NO;
    touchedEntity = nil;
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    NSArray *array = [self.entityManager getAllEntitiesPosessingComponentOfName:[TouchComponent name]];
    
#ifdef kTouchSystemSortEntities
    array = [array sortedArrayUsingDescriptors:descriptors];
#endif
   
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
        panPath = [[NSMutableArray alloc] init];
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
            
            if ([touchCom.delegate respondsToSelector:@selector(handlePan:path:)]) {
                [touchCom.delegate handlePan:kTouchStateMove path:panPath];
            }
        }
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    // End location will be the same as the last move location, so we don't add it to pan path!
    
    if (isPan && touchedEntity) {
        TouchComponent *touchCom = (TouchComponent *)[touchedEntity getComponentOfName:[TouchComponent name]];
        
        if ([touchCom.delegate respondsToSelector:@selector(handlePan:path:)]) {
            [touchCom.delegate handlePan:kTouchStateEnd path:panPath];
        }
    } else if (touchedEntity == nil) {
        // User doesn't touch anything!
        // Cancel selected entity or do something on selected entity !
        
        if (selectedEntity != nil) {
            TouchComponent *selectedEntityTouch = (TouchComponent *)[selectedEntity getComponentOfName:[TouchComponent name]];
            
            if ([selectedEntityTouch.delegate respondsToSelector:@selector(handleUnselect)]) {
                [selectedEntityTouch.delegate handleUnselect];
            }
            selectedEntity = nil;
        }
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
                
                if ([touchCom.delegate respondsToSelector:@selector(handleSelect)]) {
                    [touchCom.delegate handleSelect];
                }
            }
        } else {
            // Tap entity
            if ([touchCom.delegate respondsToSelector:@selector(handleTap)]) {
                [touchCom.delegate handleTap];
            }
        }
    }
    isBegan = NO;
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    isBegan = NO;
}


@end
