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
const static int castleDistance = 200;
const static int pathSizeHeight = 25;
const static int pathHeight = 70;

@synthesize characters = _characters;

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
        _castles = [[NSMutableArray alloc] initWithCapacity:2];
        
        // Background image
        CCSprite *map1 = [CCSprite  spriteWithFile:[file stringByAppendingString:@"_01.png"]];
        map1.anchorPoint = ccp(0, 0);
        CCSprite *map1_1 = [CCSprite  spriteWithFile:[file stringByAppendingString:@"_01.png"]];
        map1_1.anchorPoint = ccp(0, 0);
        CCSprite *map2 = [CCSprite  spriteWithFile:[file stringByAppendingString:@"_02.png"]];
        map2.anchorPoint = ccp(0, 0);
        CCSprite *map2_1 = [CCSprite  spriteWithFile:[file stringByAppendingString:@"_02.png"]];
        map2_1.anchorPoint = ccp(0, 0);
        CCSprite *map3 = [CCSprite  spriteWithFile:[file stringByAppendingString:@"_03.png"]];
        map3.anchorPoint = ccp(0, 0);
        CCSprite *map3_1 = [CCSprite  spriteWithFile:[file stringByAppendingString:@"_03.png"]];
        map3_1.anchorPoint = ccp(0, 0);
        
        CCLayerColor *background = [CCLayerColor layerWithColor:ccc4(50, 50, 50, 255)];
        // To fullfill the screen
        background.contentSize = CGSizeMake(map3.contentSize.width * 2, map3.contentSize.height + 21);
        [map3 addChild:background z:-5];
       
       	// Create a void Node, parent Node
		CCParallaxNode *voidNode = [CCParallaxNode node];
		
		// We add our children "layers"(sprite) to void node
        [voidNode addChild:map1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(0,0)];
        [voidNode addChild:map1_1 z:-1 parallaxRatio:ccp(1.0f, 1.0f) positionOffset:ccp(map1.boundingBox.size.width-1, 0)];
		[voidNode addChild:map2 z:-2 parallaxRatio:ccp(0.75f, 1.f) positionOffset:ccp(0,90)];
        [voidNode addChild:map2_1 z:-2 parallaxRatio:ccp(0.75f, 1.0f) positionOffset:ccp(map2.boundingBox.size.width-1, 90)];
        [voidNode addChild:map3 z:-3 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:ccp(0,100)];
        [voidNode addChild:map3_1 z:-3 parallaxRatio:ccp(0.5f, 1.0f) positionOffset:ccp(map3.boundingBox.size.width-1, 100)];
        
        [self addChild:voidNode];
                
        _boundaryX = map1.boundingBox.size.width*2;
        _boundaryY = map1.boundingBox.size.height*2;
        
        _cameraControl = [[MapCamera alloc] initWithMapLayer:self];
        [self addChild:_cameraControl];
        
        self.isTouchEnabled = YES;
        
//        CCLOG(@"Map size : (%f, %f)", map.boundingBox.size.width, map.boundingBox.size.height);
        
        hero = [[Character alloc] initWithId:@"209" andLevel:1];
        hero.player = 1;
        [hero.sprite addBloodSprite];
        [self addCharacter:hero];
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handelLongPress:)];
        longPress.minimumPressDuration = 0.2f;
        
        [[[CCDirector sharedDirector] view] addGestureRecognizer:longPress];
    }
    return self;
}

-(void)registerWithTouchDispatcher {
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:kTouchPriorityMap swallowsTouches:YES];
}

-(void)handelLongPress:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [hero setMoveDirection:ccp(0, 0)];
        return;
    }
    
    CGPoint location = [gestureRecognizer locationInView:[CCDirector sharedDirector].view];
    
    int halfWidth = [CCDirector sharedDirector].winSize.width / 2;
    
    if (location.x < halfWidth) {
        [hero setMoveDirection:ccp(-1, 0)];
    } else {
        [hero setMoveDirection:ccp(1, 0)];
    }
}

-(NSMutableArray *)characters {
    if (counts[0] > 0 && counts[1] > 0) {
        return _characters;
    }
    
    NSMutableArray *result = [_characters mutableCopy];
    
    for (int i = 0; i < 2; i++) {
        if (counts[i] == 0) {
            [result addObject:_castles[i]];
        }
    }
    return result;
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
    
    counts[character.player - 1]++;
}

-(void)addCastle:(Character *)castle {
    if (castle.player == 1) {
        castle.position = ccp(castleDistance, pathHeight + pathSizeHeight / 2);
        castle.sprite.anchorPoint = ccp(1, 0.5);
    } else {
        castle.position = ccp(self.boundaryX - castleDistance, pathHeight + pathSizeHeight / 2);
        castle.sprite.anchorPoint = ccp(0, 0.5);
    }
    
    [self addChild:castle.sprite];
    
    [_castles setObject:castle atIndexedSubscript:castle.player - 1];
}

-(void)setPosition:(CGPoint)position forCharacter:(Character *)character {
    character.position = position;
    [self reorderChild:character.sprite z:self.boundaryY - character.position.y];
}

-(void)removeCharacter:(Character *)character {
    [_characters removeObject:character];
    counts[character.player - 1]--;
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
        [hero useSkill];
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
