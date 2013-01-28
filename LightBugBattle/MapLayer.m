//
//  MapLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapLayer.h"
#import "CharacterInfoView.h"

@implementation MapLayer
@synthesize cameraControl;

-(id)initWithMapSprite:(CCSprite *)aSprite {
    if((self=[super init])) {
        _characters = [[NSMutableArray alloc] init];
        barriers = [[NSMutableArray alloc] init];
        
        mapBody = aSprite;
        
        boundaryX = mapBody.boundingBox.size.width / 2;
        boundaryY = mapBody.boundingBox.size.height / 2;
        
        zOrder = mapBody.boundingBox.size.height;
        
        cameraControl = [[MapCameraControl alloc] initWithMapLayer:self mapSprite:mapBody];
        
        [self setCharacterInfoViewLayer];
        
        [self addChild:cameraControl];
        [self addChild:mapBody z:-1];

        self.isTouchEnabled = YES;
        
        CCLOG(@"MAPSIZE X:%f Y:%f", mapBody.boundingBox.size.width, mapBody.boundingBox.size.height);
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
    CGSize mapSize = mapBody.boundingBox.size;
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
    [self addChild:barrier z:zOrder - barrier.collisionPosition.y];
}

-(void)removeCharacter:(Character *)character {
    [_characters removeObject:character];
}

-(void)setMapBlocks
{
    for(int x=0; x<128; x++ )
    {
        for(int y=0; y<53; y++)
        {
            float temp = CCRANDOM_0_1();
            
            if( temp > 0.8 )
            {
                mapBlock[x][y] = 1;
                CCSprite* debug = [CCSprite spriteWithFile:@"debugColor.png"];
                [mapBody addChild:debug];
                [debug setPosition:ccp( x*10, y*10 )];
            }
            else
            {
                mapBlock[x][y] = 0;
            }
        }
    }
}

-(void)moveCharacterTo:(Character*)character position:(CGPoint)position {
    [characterInfoView clean];
    
    position = [self getPositionInBoundary:position forCharacter:character];
    
    Character *c = [self getCollisionCharacterForCharacter:character atPosition:position];
    Barrier *b = [self getCollisionBarrierForCharacter:character atPosition:position];
    
    // No one occupied the position
    if (b == nil && c == nil) {
        [self setPosition:position forCharacter:character];
        [cameraControl moveCameraToX:position.x Y:position.y];
        return;
    }
    
    CGPoint collisionObjectPosition;
    float collisionObjectRadius;
    
    if (c != nil) {
        collisionObjectPosition = c.position;
        collisionObjectRadius = c.radius;
    } else {
        collisionObjectPosition = b.collisionPosition;
        collisionObjectRadius = b.collisionRadius;
    }
    
    CGPoint deltaPoint = ccpSub(position, character.position);
    CGPoint deltaCenter = ccpSub(collisionObjectPosition, character.position);
    
    CCLOG(@"%f",ccpDot(deltaPoint, deltaCenter) / (ccpLength(deltaPoint) * ccpLength(deltaCenter)));
    
    // Their cos = 1 -> 0 degree
    if (ccpDot(deltaPoint, deltaCenter) / (ccpLength(deltaPoint) * ccpLength(deltaCenter)) > 0.99) {
//        CGPoint result = ccpMult(ccpNormalize(deltaPoint),collisionObjectRadius + character.radius);
//        position = ccpAdd(collisionObjectPosition, ccpNeg(result));
//        [self setPosition:position forCharacter:character];
//        [cameraControl moveCameraToX:position.x Y:position.y];
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

    float leftAngle = remain / ccpLength(deltaCenter) / 2;

    float finalAngle = startAngle + (counterclockwise ? leftAngle : -1 * leftAngle);

    // Move around the collision object
    position = ccpAdd(collisionObjectPosition, ccpMult(ccpForAngle(finalAngle), ccpLength(deltaCenter)));
    
    // Check if someone occupied the second position.
    c = [self getCollisionCharacterForCharacter:character atPosition:position];
    b = [self getCollisionBarrierForCharacter:character atPosition:position];

    if (c == nil && b == nil) {
        [self setPosition:position forCharacter:character];
        [cameraControl moveCameraToX:position.x Y:position.y];
    } else {
        // Something is occupied the position.
    }
}

-(CGPoint)getPositionInBoundary:(CGPoint)position forCharacter:(Character *)character {
    float characterWidth = character.sprite.boundingBox.size.width/2;
    
    return ccp(MIN( MAX(position.x, -1 * boundaryX + characterWidth), boundaryX - characterWidth), MIN( MAX(position.y, -1 * boundaryY + characterWidth), boundaryY - characterWidth));
}

-(void)setPosition:(CGPoint)position forCharacter:(Character *)character {
    character.position = position;
    
    [self reorderChild:character.sprite z:zOrder - character.position.y];
}

-(void)moveCharacter:(Character*)character velocity:(CGPoint)velocity {
    if (velocity.x != 0 && velocity.y != 0) {
        [self moveCharacterTo:character position:ccpAdd(character.position, velocity)];
    }
}

-(void)knockOut:(Character*)character velocity:(CGPoint)velocity power:(float)power collision:(BOOL)collision {

    KnockOutObject* obj = [[KnockOutObject alloc] initWithCharacter:character velocity:velocity power:power collision:collision];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0/kGameSettingFps target:self selector:@selector(knockOutUpdate:) userInfo:obj repeats:YES];
}

-(void)knockOutUpdate:(NSTimer *)timer {    
    KnockOutObject *obj = timer.userInfo;
    
    Character *character = obj.character;
    
    if (obj.count >= obj.maxCount) {
        [timer invalidate];
        return;
    }
    
    obj.count++;
    obj.ratio -= obj.acceleration;
    
    CGPoint nextPosition = ccpAdd(character.position, ccpMult(obj.velocity, obj.ratio * obj.power));
    
    Character *c = [self getCollisionCharacterForCharacter:character atPosition:nextPosition];
    
    if (c != nil) {
        if (obj.collision == false) {
            // stop update;
            [timer invalidate];
        } else {
            // reflect
            obj.velocity = [Helper reflection:nextPosition vector:obj.velocity target:c.position];
            CGPoint targetPosition = ccpAdd(character.position, ccpMult(obj.velocity, obj.ratio * obj.power));
            targetPosition = [self getPositionInBoundary:targetPosition forCharacter:character];
            [self setPosition:targetPosition forCharacter:character];
        }
        return;
    }
    
    Barrier *b = [self getCollisionBarrierForCharacter:character atPosition:nextPosition];
    
    if (b != nil) {
        if (obj.collision == false) {
            [timer invalidate];
        } else {
            obj.velocity = [Helper reflection:nextPosition vector:obj.velocity target:b.position];
            CGPoint targetPosition = ccpAdd(character.position, ccpMult(obj.velocity, obj.ratio * obj.power));
            targetPosition = [self getPositionInBoundary:targetPosition forCharacter:character];
            [self setPosition:targetPosition forCharacter:character];

        }
        return;
    }
    
    [self setPosition:nextPosition forCharacter:character];
}

-(Character *)getCollisionCharacterForCharacter:(Character *)character atPosition:(CGPoint)position {
    for(Character *other in _characters) {
        if(other == character) {
            continue;
        }
        
        CGPoint targetPosition = other.position;
        float targetRadius = other.sprite.boundingBox.size.width/2;
        float selfRadius = character.sprite.boundingBox.size.width/2;
        
        if(ccpDistance(position, targetPosition) < (selfRadius + targetRadius)) {
            return other;
        }
    }
    return nil;
}

-(Barrier *)getCollisionBarrierForCharacter:(Character *)character atPosition:(CGPoint)position {
    for(Barrier *barrier in barriers) {
        CGPoint targetPosition = barrier.collisionPosition;
        float targetRadius = barrier.collisionRadius;
        float selfRadius = character.sprite.boundingBox.size.width/2;
        
        if(ccpDistance(position, targetPosition) < (selfRadius + targetRadius)) {
            return barrier;
        }
    }
    return nil;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
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