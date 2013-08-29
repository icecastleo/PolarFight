//
//  TouchSystem.m
//  CastleFight
//
//  Created by 朱 世光 on 13/8/22.
//
//

#import "TouchSystem.h"
#import "RenderComponent.h"

@interface TouchSystem() {
    EntityManager *_entityManager;
    
    NSArray *descriptors;
    
    Entity *touchedEntity;
    __weak Entity *selectedEntity;
    
    NSMutableArray *touchPositions;
    
    BOOL isMove;
    BOOL isPan;
    
    float touchPressTime;
    
    CCSprite *touchSprite;
}

@end

#define kTouchSpriteTag 12345

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

-(void)update:(ccTime)delta {
    if (_state == kTouchStateBegan) {
        if (touchPressTime > kTouchSystemLongPressTime) {
            [self handleLongPress];
        } else {
            touchPressTime += delta;
        }
        
    } else if (_state == kTouchStateMoved && isPan) {
        [self handlePan];
    }
}

-(void)handleLongPress {
    if (touchedEntity) {
        _state = kTouchStateMoved;
        isPan = YES;
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    // Prevent two touch
    if (_state != kTouchStateNone) {
        return NO;
    }
    
    _state = kTouchStateBegan;
    
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
            if ([render.sprite isKindOfClass:[CCSprite class]]) {
                [(CCSprite *)render.sprite setOpacity:50];
                touchSprite = [CCSprite spriteWithTexture:[(CCSprite *)render.sprite texture] rect:[(CCSprite *)render.sprite textureRect]];
                touchSprite.position = touchLocation;
                touchSprite.scaleX = render.sprite.scaleX;
                touchSprite.scaleY = render.sprite.scaleY;
                [touchSprite setOpacity:200];
                [render.node.parent addChild:touchSprite z:INT16_MAX tag:kTouchSpriteTag];
                
            }
            break;
        }
    }
        
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    _state = kTouchStateMoved;
    
    isMove = YES;
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    [touchPositions addObject:[NSValue valueWithCGPoint:touchLocation]];
    
    touchSprite.position = touchLocation;
    
    if (touchedEntity == nil) {
        // TODO: Move map here!
        return;
    } else {
        if (isPan == NO) {
            CGPoint previousTouchLocation = [touch previousLocationInView:[touch view]];
            previousTouchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
            
            if (ccpDistance(touchLocation, previousTouchLocation) >= kTouchSystemPanDistance || touchPositions.count > 2) {
                isPan = YES;
            }
        } else {
            //    [self handlePan];
        }
    }
}

-(void)handlePan {
    if (touchedEntity == selectedEntity) {
        // Maybe we can force the pan event only handled by select entity!
    } else {
        TouchComponent *touchCom = (TouchComponent *)[touchedEntity getComponentOfName:[TouchComponent name]];
        
        if ([touchCom.delegate respondsToSelector:@selector(handlePan:positions:)]) {
            [touchCom.delegate handlePan:kTouchStateMoved positions:touchPositions];
        }
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    _state = kTouchStateEnded;
    
    CGPoint touchLocation = [touch locationInView:[touch view]];
    touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
    
    // End location will be the same as the last move location, so we don't add it to pan path!
    
    if (touchedEntity) {
        RenderComponent *render = (RenderComponent *)[touchedEntity getComponentOfName:[RenderComponent name]];
        [(CCSprite *)render.sprite setOpacity:255];
        
        [render.node.parent removeChildByTag:kTouchSpriteTag];
    }
    
    if (isMove == NO) {
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
    } else {
        if (isPan) {
            TouchComponent *touchCom = (TouchComponent *)[touchedEntity getComponentOfName:[TouchComponent name]];
            
            if ([touchCom.delegate respondsToSelector:@selector(handlePan:positions:)]) {
                [touchCom.delegate handlePan:kTouchStateEnded positions:touchPositions];
            }
        }
    }
    _state = kTouchStateNone;
}

-(void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    _state = kTouchStateNone;
}

@end
