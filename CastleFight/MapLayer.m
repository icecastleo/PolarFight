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

//const int pathSizeHeight = 25;
const static int pathSizeHeight = 40;

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
    NSAssert(render, @"Need render component to add on map!");
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    
    CGPoint position;
    
    if (character) {
        if (team.team == 1) {
            position = ccp(kMapStartDistance, arc4random_uniform(pathSizeHeight) + kMapPathHeight);
        } else {
            position = ccp(self.boundaryX - kMapStartDistance, arc4random_uniform(pathSizeHeight) + kMapPathHeight);
        }
    } else {
        // castle
        if (team.team == 1) {
            position = ccp(kMapStartDistance - render.sprite.boundingBox.size.width/4, kMapPathHeight + pathSizeHeight/2);
        } else {
            position = ccp(self.boundaryX - kMapStartDistance + render.sprite.boundingBox.size.width/4, kMapPathHeight + pathSizeHeight/2);
        }
    }
    [self addEntity:entity toPosition:position];
}

-(void)addEntity:(Entity *)entity toPosition:(CGPoint)position {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    NSAssert(render, @"Need render component to add on map!");
    
    [self moveEntity:entity toPosition:position boundaryLimit:YES];
    [self addChild:render.node];
}

-(void)moveEntity:(Entity *)entity toPosition:(CGPoint)position boundaryLimit:(BOOL)limit {
    if (limit) {
        position = [self getPositionInBoundary:position forEntity:entity];
    }
    
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    render.position = position;
    
    [self reorderChild:render.node z:self.boundaryY - render.position.y];
}

-(void)moveEntity:(Entity *)entity byPosition:(CGPoint)position boundaryLimit:(BOOL)limit {
    if (position.x == 0 && position.y == 0) {
        return;
    }
    
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    [self moveEntity:entity toPosition:ccpAdd(render.position, position) boundaryLimit:limit];
}

-(CGPoint)getPositionInBoundary:(CGPoint)position forEntity:(Entity *)entity {
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    
    float Width = 0;
    float Height = 0;
    
    if (render.enableShadowPosition) {
        Width = render.shadowSize.width/2;
        Height = render.shadowSize.height/2;
    } else {
        Width = render.spriteBoundingBox.size.width/2;
        Height = render.spriteBoundingBox.size.height/2;
    }
    
    return ccp(MIN( MAX(Width, position.x), self.boundaryX - Width), MIN( MAX(Height, position.y), self.boundaryY - Height));
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
    // FIXME: Replace by entity action
    
    if (position.x == 0 && position.y == 0) {
        return;
    }
    RenderComponent *renderCom = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    KnockOutComponent *knockOutCom = (KnockOutComponent *)[entity getComponentOfClass:[KnockOutComponent class]];
    
    CGPoint newPos = ccpAdd(renderCom.position, position);
    if (limit) {
        newPos = [self getPositionInBoundary:newPos forEntity:entity];
    }
    
    CGPoint nodePosition = ccpAdd(renderCom.node.position, ccpSub(newPos, renderCom.position)) ;
    
    CCAction *action = [CCSequence actions:
                        [CCEaseOut actionWithAction:[CCMoveTo actionWithDuration:knockOutCom.animationDuration position:nodePosition] rate:2.0],
                        [CCCallBlock actionWithBlock:^{
                            [self moveEntity:entity toPosition:newPos boundaryLimit:NO];
                        }], nil];
    
    [renderCom.node runAction:action];
}

-(BOOL)canExecuteMagicInThisArea:(CGPoint)position {
    //TODO: add condition
    return YES;
}

-(void) summonEntity:(Entity *)entity
{
    [self addEntity:entity];
}

    


@end
