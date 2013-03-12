//
//  MapLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TiledMapLayer.h"
#import "BattleController.h"
#import "CharacterInfoView.h"
#import "Character.h"

@implementation TiledMapLayer
@synthesize cameraControl;

static float scale;

+(void)initialize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        scale = [[UIScreen mainScreen] scale];
    } else {
        scale = 1.0;
    }
}

-(id)initWithFile:(NSString *)file {
    if(self = [super init]) {
        _characters = [[NSMutableArray alloc] init];
        barriers = [[NSMutableArray alloc] init];
        
        map =  [CCTMXTiledMap tiledMapWithTMXFile:file] ;
        
        // Iterate over all the "layers" (atlas sprite managers) and set them as 'antialias'
        for(CCTMXLayer *child in [map children] ) {
            [[child texture] setAntiAliasTexParameters];
        }
        
        boundaryX = map.mapSize.width * map.tileSize.width / scale;
        boundaryY = map.mapSize.height * map.tileSize.height / scale;
        
        zOrder = boundaryY;
        
        cameraControl = [[TiledMapCamera alloc] initWithTiledMap:map];
        
        // FIXME: Move to other class?
        [self setCharacterInfoViewLayer];
        
        [self addChild:cameraControl];

        [self addChild:map z:-1];
        
        self.isTouchEnabled = YES;
        
        //        CCLOG(@"MAPSIZE X:%f Y:%f", mapBody.boundingBox.size.width, mapBody.boundingBox.size.height);
    }
    return self;
}

-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:5 swallowsTouches:YES];
}

- (void)setCharacterInfoViewLayer {
    characterInfoView = [CharacterInfoView node];
    [self addChild:characterInfoView z:zOrder + 1];
}

-(void)addCharacter:(Character*)character {

    CCTMXObjectGroup *spawnsGroup = [map objectGroupNamed:@"Spawn Layer"];
    
    NSAssert(spawnsGroup != nil, @"'Spawn Layer' not found");
    
    NSMutableDictionary *spawn;
    
    if (character.player == 1) {
        spawn = [spawnsGroup objectNamed:@"Player1"];
    } else {
        spawn = [spawnsGroup objectNamed:@"Player2"];
    }
    
    NSAssert(spawn != nil, @"Spawn object not found");
    
    int x = [[spawn valueForKey:@"x"] intValue] / CC_CONTENT_SCALE_FACTOR();
    int y = [[spawn valueForKey:@"y"] intValue] / CC_CONTENT_SCALE_FACTOR();
    
    int width = [[spawn valueForKey:@"width"] intValue] / CC_CONTENT_SCALE_FACTOR();
    int height = [[spawn valueForKey:@"height"] intValue] / CC_CONTENT_SCALE_FACTOR();
        
    CGPoint position;
    
    while (true) {

        position = ccp(x + arc4random_uniform(width), y + arc4random_uniform(height));
        
        if([self getCollisionBarrierForCharacter:character atPosition:position] == nil && [self getCollisionCharacterForCharacter:character atPosition:position] == nil) {
            character.position = position;
            [map addChild:character.sprite z:zOrder - character.position.y];
            [_characters addObject:character];
            return;
        }
    }
}

-(void)addBarrier:(Barrier *)barrier {
    [barriers addObject:barrier];
    [map addChild:barrier.sprite z:zOrder - barrier.position.y];
}

-(void)removeCharacter:(Character *)character {
    [_characters removeObject:character];
}

-(void)moveCharacter:(Character*)character toPosition:(CGPoint)position isMove:(BOOL)move{
//    CCLOG(@"%f %f",position.x, position.y);
    
    [characterInfoView clean];
    
    position = [self getPositionInBoundary:position forCharacter:character];
    
    Character *c = [self getCollisionCharacterForCharacter:character atPosition:position];
    Barrier *b = [self getCollisionBarrierForCharacter:character atPosition:position];
    
    // No one occupied the position
    if (b == nil && c == nil) {
        [self setPosition:position forCharacter:character];
        return;
    }
    
    if (!move) {
        return;
    }
    
    // If it is move, it will move around the collision object
    
    CGPoint collisionObjectPosition;
    float collisionObjectRadius;
    
    if (c != nil) {
        collisionObjectPosition = c.position;
        collisionObjectRadius = c.radius;
    } else {
        collisionObjectPosition = b.position;
        collisionObjectRadius = b.radius;
    }
    
    CGPoint deltaPoint = ccpSub(position, character.position);
    CGPoint deltaCenter = ccpSub(collisionObjectPosition, character.position);
    
    // TODO: Delete me after test, for object occupied the same position.
    if (deltaCenter.x == 0 && deltaCenter.y == 0) {
        return;
    }
    
    // Their cos = 1 -> 0 degree
    if (ccpDot(deltaPoint, deltaCenter) / (ccpLength(deltaPoint) * ccpLength(deltaCenter)) == 1) {
        //        CGPoint result = ccpMult(ccpNormalize(deltaCenter),collisionObjectRadius + character.radius);
        //        position = ccpAdd(collisionObjectPosition, ccpNeg(result));
        //        [self setPosition:position forCharacter:character];
        return;
    }
    
    CGPoint reflect = [Helper reflection:character.position vector:deltaPoint target:collisionObjectPosition];
    
    // The vector of force
    CGPoint result = ccpMult(ccpAdd(deltaPoint, reflect), 0.5);
    
    float angle = ccpToAngle(result);
    
    if (angle < 0) {
        angle += 2 * M_PI;
    }
    
    float centerAngle = ccpToAngle(deltaCenter);
    
    if (centerAngle < 0) {
        centerAngle += 2 * M_PI;
    }
    
    // Decide which way to pass the target
    BOOL counterclockwise;
    
    if (centerAngle > M_PI) {
        if (centerAngle > angle && angle > centerAngle - M_PI ) {
            counterclockwise = YES;
        } else {
            counterclockwise = NO;
        }
    } else {
        if (centerAngle + M_PI > angle && angle > centerAngle) {
            counterclockwise = NO;
        } else {
            counterclockwise = YES;
        }
    }
    
    // The length of force
    float remain = ccpLength(deltaPoint);
    
    float startAngle = ccpToAngle(ccpNeg(deltaCenter));
    
    float leftAngle = remain / ccpLength(deltaCenter);
    
    float finalAngle = startAngle + (counterclockwise ? leftAngle : -1 * leftAngle);
    
    // Move around the collision object
    position = ccpAdd(collisionObjectPosition, ccpMult(ccpForAngle(finalAngle), ccpLength(deltaCenter)));
    position = [self getPositionInBoundary:position forCharacter:character];
    
    // Check if someone occupied the second position.
    c = [self getCollisionCharacterForCharacter:character atPosition:position];
    b = [self getCollisionBarrierForCharacter:character atPosition:position];
    
    if (c == nil && b == nil) {
        [self setPosition:position forCharacter:character];
    } else {
        // Something is occupied the position.
    }
}

-(CGPoint)getPositionInBoundary:(CGPoint)position forCharacter:(Character *)character {
    return ccp(MIN( MAX(character.radius, position.x), boundaryX - character.radius), MIN( MAX(character.radius, position.y), boundaryY - character.radius));
}

-(void)setPosition:(CGPoint)position forCharacter:(Character *)character {
    character.position = position;
    
    [self reorderChild:character.sprite z:zOrder - character.position.y];
}

-(void)moveCharacter:(Character*)character byPosition:(CGPoint)position isMove:(BOOL)move {
    if (position.x == 0 && position.y == 0) {
        return;
    }
    
    [self moveCharacter:character toPosition:ccpAdd(character.position, position) isMove:move];
}

-(Character *)getCollisionCharacterForCharacter:(Character *)character atPosition:(CGPoint)position {
    for(Character *other in _characters) {
        if(other == character) {
            continue;
        }
        
        CGPoint targetPosition = other.position;
        float targetRadius = other.radius;
        float selfRadius = character.radius;
        
        if(ccpDistance(position, targetPosition) < (selfRadius + targetRadius)) {
            return other;
        }
    }
    return nil;
}

-(Barrier *)getCollisionBarrierForCharacter:(Character *)character atPosition:(CGPoint)position {
    for(Barrier *barrier in barriers) {
        CGPoint targetPosition = barrier.position;
        float targetRadius = barrier.radius;
        float selfRadius = character.radius;
        
        if(ccpDistance(position, targetPosition) < (selfRadius + targetRadius)) {
            return barrier;
        }
    }
    return nil;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
//    if ([BattleController currentInstance].state == kGameStateCharacterMove) {
//        return NO;
//    }
    
    [characterInfoView clean];
    
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint lastLocation = [touch previousLocationInView:touch.view];
    lastLocation = [[CCDirector sharedDirector] convertToGL:lastLocation];
    
    CGPoint diff = ccpSub(lastLocation, location);
    
    [cameraControl moveCameraX: 0.5 * diff.x Y: 0.5 * diff.y];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint lastLocation = [touch previousLocationInView:touch.view];
    lastLocation = [[CCDirector sharedDirector] convertToGL:lastLocation];
    
    // Tap
    if (location.x == lastLocation.x && location.y == lastLocation.y) {
        location = [self convertScreenPositionToMap:location];
        
        Character *character = [self getCharacterAtLocation:location];
        
        if (character != nil) {
            CGPoint position = [self getInfoViewPositionFromCharacterPosition:character.position];
            [characterInfoView showInfoFromCharacter:character loacation:position needBackGround:YES];
        }
    }
}

// By bounding box
// FIXME: character will overlay
-(Character *)getCharacterAtLocation:(CGPoint)location {
    for (Character *character  in _characters) {
        if (CGRectContainsPoint(character.sprite.boundingBox, location)) {
//            CCLOG(@"Find character %@ at (%f, %f)",character.name,location.x,location.y);
            return character;
        }
    }
    return nil;
}

-(CGPoint)convertScreenPositionToMap:(CGPoint)position {
    return ccpSub(position, map.position);
}

-(CGPoint)convertMapPositionToScreen:(CGPoint)position {
    return ccpAdd(position, map.position);
}

- (CGPoint)getInfoViewPositionFromCharacterPosition:(CGPoint)position {
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    position = [self convertMapPositionToScreen:position];
    
    float x,y;
    
    if (position.x < winSize.width/2) {
        x = 10;
    } else {
        // FIXME: It is not accurate
        x = winSize.width/2 + 10;
    }
    
    y = winSize.height / 10 * 2;
    
    return ccp(x, y);
}

@end