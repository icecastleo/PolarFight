//
//  MapLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapLayer.h"
#import "CharacterInfoView.h"

@interface MapLayer () {
    CharacterInfoView *_characterInfoView;
}
@end

@implementation MapLayer
@synthesize cameraControl;

const int characterPositionZ = 1000;
const int characterInfoViewZ = 9999;

-(id)initWithMapSprite:(CCSprite*)aSprite {
    if((self=[super init])) {
        _characters = [[NSMutableArray alloc] init];
        barriers = [[NSMutableArray alloc] init];
        
        knockOutObjs = [[NSMutableArray alloc] init];
        
        cameraControl = [MapCameraControl node];
        
        mapBody = aSprite;
        
        [cameraControl setMap:mapBody mapLayer:self];
        
        CharacterInfoView *characterInfoView = [CharacterInfoView node];
        _characterInfoView = characterInfoView;
        [self addChild:_characterInfoView z:characterInfoViewZ];
        
        [self addChild:cameraControl];
        [self addChild:mapBody z:0];
        
        CCLOG(@"MAPSIZE X:%f Y:%f", mapBody.boundingBox.size.width, mapBody.boundingBox.size.height);

        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:5 swallowsTouches:YES];
        
    }
    return self;
}

-(void)addCharacter:(Character*)character {
    [_characters addObject:character];
    CGSize mapSize = mapBody.boundingBox.size;
    CGSize charaSize = character.sprite.boundingBox.size;
    
    float rangeX = mapSize.width / 2 * 0.5;
    float blankX = mapSize.width / 2 * 0.25;
    float rangeY = mapSize.height * 0.5;
    
    if (character.player == 1) {
        character.position =
        ccp(
            arc4random_uniform(rangeX) - rangeX - blankX + charaSize.width / 2,
            arc4random_uniform(rangeY) - rangeY / 2
            );
    } else {
        character.position =
        ccp(
            arc4random_uniform(rangeX) + blankX + charaSize.width / 2,
            arc4random_uniform(rangeY) - rangeY / 2
            );
    }
    
    [self addChild:character.sprite z:1000 - character.position.y];
}

-(void)addBarrier:(Barrier *)theBarrier {
    [barriers addObject:theBarrier];
    [self addChild:theBarrier z:characterPositionZ - theBarrier.center.y];
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

-(void)moveCharacterTo:(Character*)theCharacter position:(CGPoint)location {
    [_characterInfoView clean];
    //int x = (location.x + mapBody.boundingBox.size.width/2)/10;
    //int y = (location.y + mapBody.boundingBox.size.height/2)/10;
    
    float moveX = theCharacter.sprite.position.x;
    float moveY = theCharacter.sprite.position.y;
    
    CGPoint possibleLocation[7];
    Boolean possibleLocationKey[7];
    
    possibleLocationKey[0] = YES;
    possibleLocationKey[1] = YES;
    possibleLocationKey[2] = YES;
    possibleLocationKey[3] = YES;
    possibleLocationKey[4] = YES;
    possibleLocationKey[5] = YES;
    possibleLocationKey[6] = YES;
    
    possibleLocation[0] = location;
    possibleLocation[1] = [Helper CGPointRotate_Axis:theCharacter.position Point:location Angle:0.4];
    possibleLocation[2] = [Helper CGPointRotate_Axis:theCharacter.position Point:location Angle:0.8];
    possibleLocation[3] = [Helper CGPointRotate_Axis:theCharacter.position Point:location Angle:1.2];
    possibleLocation[4] = [Helper CGPointRotate_Axis:theCharacter.position Point:location Angle:-0.4];
    possibleLocation[5] = [Helper CGPointRotate_Axis:theCharacter.position Point:location Angle:-0.8];
    possibleLocation[6] = [Helper CGPointRotate_Axis:theCharacter.position Point:location Angle:-1.2];
    
    
    // check character collide
    for( int i=0; i<_characters.count; i++ )
    {
        if( [_characters objectAtIndex:i] == theCharacter )
        {
            continue;
        }
        
        for( int x=0; x<7; x++ )
        {
            if( !possibleLocationKey[x] )
            {
                continue;
            }
        
            CGPoint targetLocation = [[_characters objectAtIndex:i] sprite].position;
            float targetRadius = [[_characters objectAtIndex:i] sprite].boundingBox.size.width/2;
            float selfRadius = theCharacter.sprite.boundingBox.size.width/2;
            
            if( ccpDistance(possibleLocation[x], targetLocation) < ( targetRadius + selfRadius ))
            {
                possibleLocationKey[x] = false;
            }
        }
        
    }
    
    // check barrier collide
    for( int i=0; i<barriers.count; i++ )
    {
        for( int x=0; x<7; x++ )
        {
            if( !possibleLocationKey[x] )
            {
                continue;
            }
            
            CGPoint targetLocation = [[barriers objectAtIndex:i] center];
            
            float targetRadius = [[barriers objectAtIndex:i] radius];
            float selfRadius = theCharacter.sprite.boundingBox.size.width/2;
            
            if( ccpDistance(possibleLocation[x], targetLocation) < ( targetRadius + selfRadius ))
            {
                possibleLocationKey[x] = false;
            }
        }
    }
    
    // Decide which point to walk
    for( int i=0; i<7; i++ )
    {
        if( possibleLocationKey[i] )
        {
            moveX = possibleLocation[i].x;
            moveY = possibleLocation[i].y;
            break;
        }
    }
    
////    CCLOG(@"PLAYER BLOCK x:%i y:%i", x, y);
//    
//    // Character Collide with Character
//    for( int i=0; i<characters.count; i++ )
//    {
//        if( [characters objectAtIndex:i] == theCharacter )
//        {
//            continue;
//        }
//        
//        CGPoint targetLocation = [[characters objectAtIndex:i] position];
//        CGPoint selfLocation = theCharacter.position;
//        
//        float targetRadius = [[characters objectAtIndex:i] sprite].boundingBox.size.width/2;
//        float selfRadius = theCharacter.sprite.boundingBox.size.width/2;
//        
//        // redirect the location
//        if( ccpDistance(targetLocation, location ) < (targetRadius + selfRadius ) )
//        {
//            CGPoint redirect = [Helper moveRedirectWhileCollisionP1:selfLocation R1:selfRadius P2:targetLocation R2:targetRadius Location:location];
//            
//            moveX = redirect.x;
//            moveY = redirect.y;
//        }
//        // redirect the location
//    }
//    // Character Collide with Character
//    
//    // Character Collide with Barriers
//    for( int i=0; i<barriers.count; i++ )
//    {
//        CGPoint targetLocation = [[barriers objectAtIndex:i] center];
//        CGPoint selfLocation = theCharacter.position;
//        
//        float targetRadius = [[barriers objectAtIndex:i] radius];
//        float selfRadius = theCharacter.sprite.boundingBox.size.width/2;
//        
//        // redirect the location
//        if( ccpDistance(targetLocation, location ) < (targetRadius + selfRadius ) )
//        {
//            CGPoint redirect = [Helper moveRedirectWhileCollisionP1:selfLocation R1:selfRadius P2:targetLocation R2:targetRadius Location:location];
//            
//            moveX = redirect.x;
//            moveY = redirect.y;
//        }
//        // redirect the location
//    }
//    // Character Collide with Barriers

    
    
    // MAP LIMIT
    float mapXLimit = mapBody.boundingBox.size.width/2;
    float mapYLimit = mapBody.boundingBox.size.height/2;
    float characterWidth = theCharacter.sprite.boundingBox.size.width/2;
    
    moveX = MIN( MAX( moveX, -1*mapXLimit + characterWidth ), mapXLimit - characterWidth);
    moveY = MIN( MAX( moveY, -1*mapYLimit + characterWidth ), mapYLimit - characterWidth);
    // MAP LIMIT END
//    CCLOG(@"LIMITS X:%f Y:%f", mapXLimit, mapYLimit);
//    CCLOG(@"CHARA POSITION X:%f Y:%f", theCharacter.position.x, theCharacter.position.y);
    
    [self reorderChild:theCharacter.sprite z: characterPositionZ - moveY];
    
    theCharacter.position = ccp(moveX,moveY);
    
    [cameraControl moveCameraToX:moveX Y:moveY];
}

-(void)moveCharacter:(Character*)theCharacter velocity:(CGPoint)velocity {
    if (velocity.x != 0 && velocity.y != 0) {
        [self moveCharacterTo:theCharacter position:ccpAdd(theCharacter.position, velocity)];
    }
    
    // TODO: Give the final velocity to character.
    // The best way is return a final velocity, and let the |setCharacterWithVelocity| out of here.
    [theCharacter setDirectionVelocity:velocity];
}

-(void)knockOut:(Character*)character velocity:(CGPoint)velocity power:(float)power {
//    float angle = [Helper calculateVectorAngle:velocity];
//    CGPoint direction = [Helper vectorFromAngle:angle];
//    
//    float power = ccpDistance(velocity, direction);
//    
//    power *= 0.15; // edit someday
    
    //CCLOG(@"ANGLE : %f, ANGLE 2: %f, POWER : %f", angle, [Helper calculateVectorAngle:direction], power);
    KnockOutObject* obj = [[KnockOutObject alloc] initWithCharacter:character velocity:velocity power:power];
    
    [NSTimer scheduledTimerWithTimeInterval:0.025f target:self selector:@selector(knockOutUpdate:) userInfo:obj repeats:YES];
}

-(void)knockOutUpdate:(NSTimer *)timer {

    KnockOutObject *obj = timer.userInfo;
    
    Character *theCharacter = obj.character;
    
    if (obj.count >= kKnoutOutCount) {
        [timer invalidate];
    } else {
        obj.count++;
        obj.ratio *= kKnoutOutRatio;
        CGPoint nextPoint = ccpAdd(theCharacter.position, ccpMult(obj.velocity, obj.ratio * obj.power));
        
        // Check character collide
        for(Character *other in _characters) {
            if(other == theCharacter) {
                continue;
            }
            
            CGPoint targetLocation = other.position;
            float targetRadius = other.sprite.boundingBox.size.width/2;
            float selfRadius = theCharacter.sprite.boundingBox.size.width/2;
            
            if(ccpDistance(nextPoint, targetLocation) < (targetRadius + selfRadius)) {
                obj.velocity = [Helper vectorBounce_self:nextPoint vector:obj.velocity target:targetLocation];
            }
        }
        
        // Check barrier collide
        for(Barrier *barrier in barriers) {
            CGPoint targetLocation = barrier.center;
            float targetRadius = barrier.radius;
            float selfRadius = theCharacter.sprite.boundingBox.size.width/2;
                
            if(ccpDistance(nextPoint, targetLocation) < (targetRadius + selfRadius)) {
                obj.velocity = [Helper vectorBounce_self:nextPoint vector:obj.velocity target:targetLocation];
            }
        }
        theCharacter.position = ccpAdd(theCharacter.position, ccpMult(obj.velocity, obj.ratio * obj.power));
        
        [self reorderChild:theCharacter.sprite z:characterPositionZ - theCharacter.position.y];
    }
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [_characterInfoView clean];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    CGPoint actualLocation = [self getTouchPositionInMapFromOriginalTouchLocation:location];
    [self selectCharacterForTouch:actualLocation];
    
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

- (void)selectCharacterForTouch:(CGPoint)touchLocation {
    for (Character *character  in _characters) {
        if (CGRectContainsPoint(character.sprite.boundingBox, touchLocation)) {
            CGPoint position = [self getInfoViewPositionFromCharacterPosition:character.position];
            [_characterInfoView showInfoFromCharacter:character loacation:position needBackGround:YES];
            CCLOG(@"touch %@ ::(X:%g,Y:%g)",character.name,touchLocation.x,touchLocation.y);
            break;
        }
    }
}

- (CGPoint)getTouchPositionInMapFromOriginalTouchLocation:(CGPoint)point {
    CGPoint cameraPosition = [cameraControl getCameraPosition];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    double x = point.x + cameraPosition.x - winSize.width/2;
    double y = point.y + cameraPosition.y - winSize.height/2;
    CGPoint goal = CGPointMake(x, y);
    
    return goal;
}

- (CGPoint)getInfoViewPositionFromCharacterPosition:(CGPoint)chaPoint {
    CGPoint cameraPosition = [cameraControl getCameraPosition];
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    double x=0,y=0;
    if (chaPoint.x < cameraPosition.x) 
        x = cameraPosition.x + 10;
    else
        x = cameraPosition.x - winSize.width/2 + winSize.width/20;
    
    y = cameraPosition.y - winSize.height/2 + winSize.height/5;
    CGPoint goal = CGPointMake(x, y);
    
    return goal;
}

@end
