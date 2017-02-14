//
//  TouchSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/8/22.
//
//

#import "TouchSystem.h"
#import "RenderComponent.h"

typedef enum {
    kTouchStateNone,
    kTouchStateBegan,
    kTouchStateMoved,
    kTouchStateEnded,
} TouchState;

@interface TouchSystem() {
    EntityManager *_entityManager;
    
    NSArray *descriptors;
    
    Entity *touchedEntity;
    __weak Entity *selectedEntity;
    
    NSMutableArray *touchPositions;
    
    TouchState state;
    BOOL isMove;
    BOOL isPan;

    float touchPressTime;
    
    MapLayer *map;
}

@end

@implementation TouchSystem

-(id)initWithEntityManager:(EntityManager *)entityManager {
    if (self = [super init]) {
        _entityManager = entityManager;
        
        touchedEntity = nil;
        selectedEntity = nil;
      
        [self scheduleUpdate];
        
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

-(void)setMapLayer:(MapLayer *)mapLayer {
    map = mapLayer;
}

-(void)update:(ccTime)delta {
    if (state == kTouchStateBegan) {
        if (touchPressTime > kTouchSystemLongPressTime) {
            [self handleLongPress];
        } else {
            touchPressTime += delta;
        }
        
    } else if (state == kTouchStateMoved && isPan) {
        [self handlePan:kPanStateMoved];
    }
}

-(void)handleLongPress {
    if (touchedEntity) {
        state = kTouchStateMoved;
        
        isMove = YES;
        isPan = YES;
        
        [self handlePan:kPanStateBegan];
    }
}

-(void)showTouchSprite:(BOOL)show {
    RenderComponent *render = (RenderComponent *)[touchedEntity getComponentOfName:[RenderComponent name]];
    if (show) {
        TouchComponent *touchCom = (TouchComponent *)[touchedEntity getComponentOfName:[TouchComponent name]];
//        [(CCSprite *)render.sprite setOpacity:0];
        [render.node addChild:touchCom.touchSprite z:0 tag:kSelectedImageTag];
    } else {
//        [(CCSprite *)render.sprite setOpacity:255];
        if ([render.node getChildByTag:kSelectedImageTag]) {
            [render.node removeChildByTag:kSelectedImageTag cleanup:YES];
        }
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // Prevent two touch
    if (state != kTouchStateNone) {
        return NO;
    }
    
    state = kTouchStateBegan;
    
    // Reset variable
    touchPressTime = 0;
    isMove = NO;
    isPan = NO;

    touchedEntity = nil;
    touchPositions = [[NSMutableArray alloc] init];
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    [touchPositions addObject:[NSValue valueWithCGPoint:touchLocation]];
    
    NSArray *array = [_entityManager getAllEntitiesPosessingComponentOfName:[TouchComponent name]];
    
#ifdef kTouchSystemSortEntities
    array = [array sortedArrayUsingDescriptors:descriptors];
#endif
   
    for (Entity *entity in array) {
        RenderComponent *render = (RenderComponent *)[entity getComponentOfName:[RenderComponent name]];
        TouchComponent *touchCom = (TouchComponent *)[entity getComponentOfName:[TouchComponent name]];
        
        if (touchCom.touchable && CGRectContainsPoint(render.sprite.boundingBox, [render.sprite.parent convertToNodeSpace:touchLocation])) {
            touchedEntity = entity;
            [self showTouchSprite:YES];
            break;
        }
    }
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    [touchPositions addObject:[NSValue valueWithCGPoint:touchLocation]];
    
    if (isMove == NO) {
        CGPoint previousTouchLocation = [touch previousLocationInView:[touch view]];
        previousTouchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        
        if (ccpDistance(touchLocation, previousTouchLocation) >= kTouchSystemMinimumMoveDistance || touchPositions.count > 2) {
            state = kTouchStateMoved;
            isMove = YES;
        } else {
            // isMove == NO
            return;
        }
    }
    
    if (touchedEntity == nil) {
        // Move map here!
        CGPoint lastLocation = [touch previousLocationInView:touch.view];
        lastLocation = [[CCDirector sharedDirector] convertToGL:lastLocation];
        
        CGPoint diff = ccpSub(lastLocation, touchLocation);
        
        [map.cameraControl moveBy:ccpMult(diff, 0.5)];
        return;
    } else {
        if (isPan == NO) {
            isPan = YES;
            [self handlePan:kPanStateBegan];
        }
    }
}

-(void)handlePan:(PanState)panState {
    if (touchedEntity == selectedEntity) {
        // Maybe we can force the pan event only handled by select entity!
    } else {
        TouchComponent *touchCom = (TouchComponent *)[touchedEntity getComponentOfName:[TouchComponent name]];
        
        if ([touchCom.delegate respondsToSelector:@selector(handlePan:positions:)]) {
            [touchCom.delegate handlePan:panState positions:touchPositions];
        }else {
            RenderComponent *render = (RenderComponent *)[touchedEntity getComponentOfName:[RenderComponent name]];
            if (!CGRectContainsPoint(render.sprite.boundingBox, [render.sprite.parent convertToNodeSpace:[[touchPositions lastObject] CGPointValue]])) {
                [self showTouchSprite:NO];
            }
        }
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    state = kTouchStateEnded;
    [self showTouchSprite:NO];
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    // End location will be the same as the last move location, so we don't add it to pan path!
    
    if (isMove) {
        if (isPan) {
            [self handlePan:kPanStateEnded];
        }
    } else {
        if (touchedEntity == nil) {
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
    }
    state = kTouchStateNone;
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    state = kTouchStateNone;
}

@end
