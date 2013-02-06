//
//  MapLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapLayer.h"
#import "BattleController.h"
#import "CharacterInfoView.h"

@implementation MapLayer
@synthesize cameraControl;

-(id)initWithMapSprite:(CCSprite *)aSprite {
    if((self=[super init])) {
        _characters = [[NSMutableArray alloc] init];
        barriers = [[NSMutableArray alloc] init];
        
        mapSprite = aSprite;
        
        boundaryX = mapSprite.boundingBox.size.width / 2;
        boundaryY = mapSprite.boundingBox.size.height / 2;
        
        zOrder = mapSprite.boundingBox.size.height;
        
        cameraControl = [[MapCameraControl alloc] initWithMapLayer:self mapSprite:mapSprite];
        
        [self setCharacterInfoViewLayer];
        
        [self addChild:cameraControl];
        [self addChild:mapSprite z:-1];

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
    [_characters addObject:character];
    CGSize mapSize = mapSprite.boundingBox.size;
    CGSize charaSize = character.sprite.boundingBox.size;
    
    float rangeX = mapSize.width / 2 * 0.5;
    float blankX = mapSize.width / 2 * 0.25;
    float rangeY = mapSize.height * 0.5;
    
    CGPoint position;
    
    while (true) {
        if (character.player == 1) {
            position = ccp(arc4random_uniform(rangeX) - rangeX - blankX + charaSize.width / 2, arc4random_uniform(rangeY) - rangeY / 2);
        } else {
            position = ccp(arc4random_uniform(rangeX) + blankX + charaSize.width / 2, arc4random_uniform(rangeY) - rangeY / 2);
        }
        
        if([self getCollisionBarrierForCharacter:character atPosition:position] == nil && [self getCollisionCharacterForCharacter:character atPosition:position] == nil) {
            character.position = position;
            [self addChild:character.sprite z:zOrder - character.position.y];
            return;
        }
    }
}

-(void)addBarrier:(Barrier *)barrier {
    [barriers addObject:barrier];
    [self addChild:barrier.sprite z:zOrder - barrier.position.y];
}

-(void)removeCharacter:(Character *)character {
    [_characters removeObject:character];
}

//-(void)setMapBlocks
//{
//    for(int x=0; x<128; x++ )
//    {
//        for(int y=0; y<53; y++)
//        {
//            float temp = CCRANDOM_0_1();
//            
//            if( temp > 0.8 )
//            {
//                mapBlock[x][y] = 1;
//                CCSprite* debug = [CCSprite spriteWithFile:@"debugColor.png"];
//                [mapBody addChild:debug];
//                [debug setPosition:ccp( x*10, y*10 )];
//            }
//            else
//            {
//                mapBlock[x][y] = 0;
//            }
//        }
//    }
//}

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
    float characterWidth = character.sprite.boundingBox.size.width/2;
    float characterHeight = character.sprite.boundingBox.size.height/2;
    
    return ccp(MIN( MAX(position.x, -1 * boundaryX + characterWidth), boundaryX - characterWidth), MIN( MAX(position.y, -1 * boundaryY + characterHeight), boundaryY - characterHeight));
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
    if ([BattleController currentInstance].state == kGameStateCharacterMove) {
        return NO;
    }
    
    [characterInfoView clean];
    
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint lastPoint = [touch previousLocationInView:touch.view];
    lastPoint = [[CCDirector sharedDirector] convertToGL:lastPoint];
    
    CGPoint diff = ccp( location.x - lastPoint.x, location.y - lastPoint.y );
    [cameraControl moveCameraX: -0.5 * diff.x Y: -0.5 * diff.y];
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint lastPoint = [touch previousLocationInView:touch.view];
    lastPoint = [[CCDirector sharedDirector] convertToGL:lastPoint];

    // Tap
    if (location.x == lastPoint.x && location.y == lastPoint.y) {
        location = [self convertLocationToMapLocation:location];
        
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
            CCLOG(@"Find character %@ at (%f, %f)",character.name,location.x,location.y);
            return character;
        }
    }
    return nil;
}

-(CGPoint)convertLocationToMapLocation:(CGPoint)location {
    
    CGPoint cameraPosition = cameraControl.cameraPosition;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    // Camara position is at the center of the screen
    double x = location.x + cameraPosition.x - winSize.width/2;
    double y = location.y + cameraPosition.y - winSize.height/2;
    
    return ccp(x, y);
}

- (CGPoint)getInfoViewPositionFromCharacterPosition:(CGPoint)chaPoint {
    CGPoint cameraPosition = cameraControl.cameraPosition;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    float x,y;
    
    if (chaPoint.x < cameraPosition.x)
        x = cameraPosition.x + 10;
    else
        x = cameraPosition.x - winSize.width/2 + 10;
    
    y = cameraPosition.y - winSize.height/2 + winSize.height/5;
    
    return ccp(x, y);
}

@end