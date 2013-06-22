//
//  MapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/1.
//
//

#import "MapLayer.h"
#import "BattleController.h"
#import "TeamComponent.h"
#import "RenderComponent.h"
#import "CharacterComponent.h"
#import "KnockOutComponent.h"

@implementation MapLayer

@dynamic maxChildZ;

static float scale;
const static int castleDistance = 200;
//const static int pathSizeHeight = 25;
const static int pathSizeHeight = 100;
//const static int pathHeight = 70;
const static int pathHeight = 60;

+(void)initialize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    } else {
        scale = 1.0;
    }
}

-(id)initWithName:(NSString *)name {
    if(self = [super init]) {
        [self setMap:name];
        
        _cameraControl = [[MapCamera alloc] initWithMapLayer:self];
        [self addChild:_cameraControl];
        
        [self setTouchEnabled:YES];
        
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handelLongPress:)];
//        longPress.minimumPressDuration = 0.2f;
//        
//        [[[CCDirector sharedDirector] view] addGestureRecognizer:longPress];
    }
    return self;
}

-(void)setMap:(NSString *)name {
    // You must set map sprite and contentSize
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:[NSString stringWithFormat:@"You must override %@ in a %@ subclass", NSStringFromSelector(_cmd), NSStringFromClass([self class])] userInfo:nil];
}

-(int)boundaryX {
    return self.contentSize.width;
}

-(int)boundaryY {
    return self.contentSize.height;
}

-(int)maxChildZ {
    return self.boundaryY;
}

-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kTouchPriorityMap swallowsTouches:YES];
}

//-(void)handelLongPress:(UIGestureRecognizer *)gestureRecognizer {
//    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        [hero setMoveDirection:ccp(0, 0)];
//        return;
//    }
//    
//    CGPoint location = [gestureRecognizer locationInView:[CCDirector sharedDirector].view];
//    
//    int halfWidth = [CCDirector sharedDirector].winSize.width / 2;
//    
//    if (location.x < halfWidth) {
//        [hero setMoveDirection:ccp(-1, 0)];
//    } else {
//        [hero setMoveDirection:ccp(1, 0)];
//    }
//}

-(void)addEntity:(Entity *)entity {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    if (!render) {
        return;
    }
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    
    CGPoint position;
    
    if (character) {
        if (team.team == 1) {
            position = ccp(castleDistance, arc4random_uniform(pathSizeHeight) + pathHeight);
        } else {
            position = ccp(self.boundaryX - castleDistance, arc4random_uniform(pathSizeHeight) + pathHeight);
        }
    } else {
        // castle
        if (team.team == 1) {
            position = ccp(castleDistance, pathHeight + pathSizeHeight/2);
            render.sprite.anchorPoint = ccp(1, 0.5);
        } else {
            position = ccp(self.boundaryX - castleDistance, pathHeight + pathSizeHeight / 2);
            render.sprite.anchorPoint = ccp(0, 0.5);
        }
    }
    [self addEntityWithPosition:entity toPosition:position];
    
}

-(void) addEntityWithPosition:(Entity *)entity toPosition:(CGPoint)position{
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    if (!render) {
        return;
    }
    
    [self moveEntity:entity toPosition:position boundaryLimit:YES];
    [self addChild:render.sprite];
}

-(void)moveEntity:(Entity *)entity toPosition:(CGPoint)position boundaryLimit:(BOOL)limit {
    if (limit) {
        position = [self getPositionInBoundary:position forEntity:entity];
    }
    
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    renderCom.position = position;
    [self reorderChild:renderCom.sprite z:self.boundaryY - renderCom.position.y];
}

-(void)moveEntity:(Entity *)entity byPosition:(CGPoint)position boundaryLimit:(BOOL)limit {
    if (position.x == 0 && position.y == 0) {
        return;
    }
    
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    [self moveEntity:entity toPosition:ccpAdd(renderCom.position, position) boundaryLimit:limit];
}

-(CGPoint)getPositionInBoundary:(CGPoint)position forEntity:(Entity *)entity {
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    
    float halfWidth = renderCom.sprite.boundingBox.size.width/kShadowWidthDivisor/2;
    float halfHeight = renderCom.sprite.boundingBox.size.height/kShadowHeightDivisor/2;
    
    return ccp(MIN( MAX(halfWidth, position.x), self.boundaryX - halfWidth), MIN( MAX(halfHeight, position.y), self.boundaryY - halfHeight));
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint lastLocation = [touch previousLocationInView:touch.view];
    lastLocation = [[CCDirector sharedDirector] convertToGL:lastLocation];
    
    CGPoint diff = ccpSub(lastLocation, location);
    
    [_cameraControl moveBy:ccpMult(diff, 0.5)];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    // map location
//    CGPoint location = [self convertTouchToNodeSpace:touch];
    
//    // win location
//    location = [touch locationInView:[CCDirector sharedDirector].view];
//    location = [[CCDirector sharedDirector] convertToGL: location];
}


-(void)knockOutEntity:(Entity *)entity byPosition:(CGPoint)position boundaryLimit:(BOOL)limit {
    if (position.x == 0 && position.y == 0) {
        return;
    }
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    KnockOutComponent *knockOutCom = (KnockOutComponent *)[entity getComponentOfClass:[KnockOutComponent class]];
    
    CGPoint newPos = ccpAdd(renderCom.position, position);
    if (limit) {
        newPos = [self getPositionInBoundary:newPos forEntity:entity];
    }
    CGPoint spritePosition = ccpAdd(renderCom.sprite.position, ccpAdd(newPos, ccpMult(renderCom.position, -1))) ;
    
    CCAction *action = [CCSequence actions:
                        [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:knockOutCom.animationDuration position:spritePosition] rate:2.0],
                        [CCCallBlock actionWithBlock:^{
                            renderCom.position = newPos;
                            [self reorderChild:renderCom.sprite z:self.boundaryY - renderCom.position.y];
                    }], nil];
    
    [renderCom.sprite runAction:action];
}

@end
