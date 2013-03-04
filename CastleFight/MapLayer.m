//
//  MapLayer.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/1.
//
//

#import "MapLayer.h"

@implementation MapLayer

static float scale;
const static int castleDistance = 100;
const static int pathSizeHeight = 50;
const static int pathHeight = 60;

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
        
        CCSprite *map = [CCSprite spriteWithFile:file];
        map.anchorPoint = ccp(0, 0);
        [self addChild:map z:-1];
        
        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(50, 50, 50, 255)];
        background.contentSize = map.contentSize;
        [self addChild:background z:-5];
        
        _boundaryX = map.boundingBox.size.width;
        _boundaryY = map.boundingBox.size.height;
        
        _cameraControl = [[MapCamera alloc] initWithMapLayer:self];
        [self addChild:_cameraControl];
        
        self.isTouchEnabled = YES;
        
//        CCLOG(@"Map size : (%f, %f)", map.boundingBox.size.width, map.boundingBox.size.height);
    }
    return self;
}

-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:5 swallowsTouches:YES];
}

-(void)addCharacter:(Character *)character {
    
    CGPoint position;
    
    if (character.player == 1) {
        position = ccp(castleDistance, arc4random_uniform(pathSizeHeight) + pathHeight);
    } else {
        position = ccp(self.boundaryX - castleDistance, arc4random_uniform(pathSizeHeight) + pathHeight);
    }

    [self setPosition:position forCharacter:character];

    [self addChild:character.sprite];
    [_characters addObject:character];
}

-(void)addCastle:(Character *)castle {
    if (castle.player == 1) {
        NSAssert(_playerCastle == nil, @"Add second castle!!");
        
        _playerCastle = castle;
        _playerCastle.position = ccp(castleDistance / 2, pathHeight);
    } else {
        NSAssert(_enemyCastle == nil, @"Add second castle!!");
        
        _enemyCastle = castle;
        _enemyCastle.position = ccp(self.boundaryX - castleDistance / 2, pathHeight);
    }
    
    [self addChild:castle.sprite];
    
    // FIXME: Seperate from characters.
    [_characters addObject:castle];
}

-(void)setPosition:(CGPoint)position forCharacter:(Character *)character {
    character.position = position;
    [self reorderChild:character.sprite z:self.boundaryY - character.position.y];
}

-(void)removeCharacter:(Character *)character {
    [_characters removeObject:character];
}

-(void)moveCharacter:(Character*)character toPosition:(CGPoint)position isMove:(BOOL)move{
//    CCLOG(@"%f %f",position.x, position.y);
    position = [self getPositionInBoundary:position forCharacter:character];
    [self setPosition:position forCharacter:character];
}

-(CGPoint)getPositionInBoundary:(CGPoint)position forCharacter:(Character *)character {
    return ccp(MIN( MAX(character.radius, position.x), self.boundaryX - character.radius), MIN( MAX(character.radius, position.y), self.boundaryY - character.radius));
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

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

-(void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint lastLocation = [touch previousLocationInView:touch.view];
    lastLocation = [[CCDirector sharedDirector] convertToGL:lastLocation];
    
    CGPoint diff = ccpSub(lastLocation, location);
    
    [_cameraControl moveCameraX: 0.5 * diff.x Y: 0.5 * diff.y];
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
            // TODO: ?
        }
    }
}

// By bounding box
// FIXME: character will overlay
-(Character *)getCharacterAtLocation:(CGPoint)location {
    for (Character *character  in _characters) {
        if (CGRectContainsPoint(character.sprite.boundingBox, location)) {
            CCLOG(@"Find player %d's %@ at (%f, %f)",character.player, character.name, location.x, location.y);
            return character;
        }
    }
    return nil;
}

-(CGPoint)convertScreenPositionToMap:(CGPoint)position {
    return ccpSub(position, self.position);
}

-(CGPoint)convertMapPositionToScreen:(CGPoint)position {
    return ccpAdd(position, self.position);
}

@end
