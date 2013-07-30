//
//  ThreeLineMapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/4/29.
//
//

#import "ThreeLineMapLayer.h"
#import "RenderComponent.h"
#import "TeamComponent.h"
#import "CharacterComponent.h"
#import "SelectableComponent.h"

typedef enum {
    kMoveTypeZone,
    kMoveTypeMap,
    kMoveTypeLine,
} MoveType;

@interface ThreeLineMapLayer() {
    int selectLine;
    CCLayer *lineLayer;
    
    MoveType mType;
    
    NSMutableDictionary *prepareEntities;
}
@end

@implementation ThreeLineMapLayer

-(id)initWithName:(NSString *)name {
    if (self = [super initWithName:name]) {
        selectLine = 0;
        [self initLineLayer];
        prepareEntities = [[NSMutableDictionary alloc] initWithCapacity:kMapPathMaxLine];
        
        [self schedule:@selector(sendPrepareEntities) interval:3.0];
    }
    return self;
}

-(void)initLineLayer {
    lineLayer = [[CCLayer alloc] init];
    
    for(int i = 0; i < kMapPathMaxLine; i++) {
        CCSprite *lineArrow = [CCSprite spriteWithFile:@"black_arrow.png"];
        lineArrow.position = ccp(lineArrow.boundingBox.size.width/2, kMapPathFloor + i*kMapPathHeight + kMapPathHeight/2);
        [lineArrow setOpacity:128];
        [lineLayer addChild:lineArrow z:0 tag:i];
    }
    
    CCSprite *selectLineArrow = (CCSprite *)[lineLayer getChildByTag:selectLine];
    [selectLineArrow setOpacity:255];
}

-(BOOL)isSelectLineOccupied {
    if ([prepareEntities objectForKey:[NSNumber numberWithInt:selectLine]]) {
        return YES;
    } else {
        return NO;
    }
}

-(void)sendPrepareEntities {
    for (Entity *entity in prepareEntities.allValues) {
        [entity sendEvent:kEntityEventReady Message:nil];
    }
    
    [prepareEntities removeAllObjects];
}

-(void)setParent:(CCNode *)parent {
    [super setParent:parent];
    [parent addChild:lineLayer z:_zOrder+1];
}

-(void)setMap:(NSString *)name {
    CCParallaxNode *node = [CCParallaxNode node];
    
    CCSprite *temp = [CCSprite spriteWithFile:@"ice.png"];
    int width = temp.contentSize.width;
    int height = temp.contentSize.height;
    
    int repeat = 3;
    
    for(int i = 0; i < repeat; i++) {
        CCSprite *map = [CCSprite spriteWithFile:@"ice.png"];
        map.anchorPoint = ccp(0, 0);
        [node addChild:map z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp((width-1)*i, 0)];
    }
    
    [self addChild:node];
    self.contentSize = CGSizeMake(width*repeat, height);
}

-(void)addEntity:(Entity *)entity {
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    
    if (team.team == 1) {
        [self addEntity:entity line:selectLine];
    } else {
        [self addEntity:entity line:arc4random_uniform(kMapPathMaxLine)];
    }
}

-(void)addEntity:(Entity *)entity line:(int)line {
    
    RenderComponent *render = (RenderComponent *)[entity getComponentOfClass:[RenderComponent class]];
    NSAssert(render, @"Need render component to add on map!");
    
    TeamComponent *team = (TeamComponent *)[entity getComponentOfClass:[TeamComponent class]];
    CharacterComponent *character = (CharacterComponent *)[entity getComponentOfClass:[CharacterComponent class]];
    
    CGPoint position;
    
    if (character) {
        if (team.team == 1) {
            position = ccp(kMapStartDistance, kMapPathFloor + line*kMapPathHeight + arc4random_uniform(kMapPathRandomHeight));
            [prepareEntities setObject:entity forKey:[NSNumber numberWithInt:selectLine]];
            [entity sendEvent:kEntityEventPrepare Message:nil];
        } else {
            position = ccp(self.boundaryX - kMapStartDistance, kMapPathFloor + line*kMapPathHeight + arc4random_uniform(kMapPathRandomHeight));
        }
    } else {
        // castle
        if (team.team == 1) {
            position = ccp(kMapStartDistance - render.sprite.boundingBox.size.width/4, kMapPathFloor + kMapPathHeight/2);
        } else {
            position = ccp(self.boundaryX - kMapStartDistance + render.sprite.boundingBox.size.width/4, kMapPathFloor + kMapPathHeight/2);
        }
    }
    [self addEntity:entity toPosition:position];
}

-(BOOL)canExecuteMagicInThisArea:(CGPoint)position {
    int boundaryTop = kMapPathFloor + kMapPathHeight * kMapPathMaxLine;
    int boundaryBottom = kMapPathFloor;
    int boundaryLeft = 0;
    int boundaryRight = self.boundaryX;
    
    if (position.x > boundaryLeft && position.x < boundaryRight && position.y > boundaryBottom && position.y < boundaryTop) {
        return YES;
    }
    
    return NO;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (mType == kMoveTypeZone) {
        CGPoint lastLocation = [touch previousLocationInView:touch.view];
        lastLocation = [[CCDirector sharedDirector] convertToGL:lastLocation];
        
        CGPoint diff = ccpSub(lastLocation, location);
        
        if (abs(diff.x) > abs(diff.y)) {
            mType = kMoveTypeMap;
        } else {
            mType = kMoveTypeLine;
        }
    }
    
    if (mType == kMoveTypeMap) {
        CGPoint lastLocation = [touch previousLocationInView:touch.view];
        lastLocation = [[CCDirector sharedDirector] convertToGL:lastLocation];
        
        CGPoint diff = ccpSub(lastLocation, location);
        
        [self.cameraControl moveBy:ccpMult(diff, 0.5)];
    } else if (mType == kMoveTypeLine) {
        int line = (location.y - kMapPathFloor)/kMapPathHeight;
        
        if (line >= kMapPathMaxLine) {
            line = kMapPathMaxLine - 1;
        } else if (line < 0) {
            line = 0;
        }
        
        CCSprite *previousLineArrow = (CCSprite *)[lineLayer getChildByTag:selectLine];
        [previousLineArrow setOpacity:128];
        
        selectLine = line;
        
        CCSprite *selectLineArrow = (CCSprite *)[lineLayer getChildByTag:selectLine];
        [selectLineArrow setOpacity:255];
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    mType = kMoveTypeZone;
}

@end
