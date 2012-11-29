//
//  MapLayer.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/1.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapLayer.h"

@implementation MapLayer
@synthesize cameraControl;

-(id) init
{
    if((self=[super init]))
    {
        cameraControl = [MapCameraControl node];
        characters = [[NSMutableArray alloc] init];
        barriers = [[NSMutableArray alloc] init];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:5 swallowsTouches:YES];
    }
    return self;
}

-(void) addCharacter:(Character*)theCharacter
{
    [characters addObject:theCharacter];
    CGSize mapSize = mapBody.boundingBox.size;
    CGSize charaSize = theCharacter.sprite.boundingBox.size;
    
    // Need to be done at map
    if(theCharacter.player == 1)
    {
        theCharacter.position =
        ccp(
            -1*CCRANDOM_0_1()*mapSize.width/2*0.8 + charaSize.width/2,
            CCRANDOM_0_1()*mapSize.height*0.8 - mapSize.height/2
            );
    }
    else
    {
        theCharacter.position =
        ccp(
            CCRANDOM_0_1()*mapSize.width/2*0.8 - charaSize.width/2,
            CCRANDOM_0_1()*mapSize.height*0.8 - mapSize.height/2
            );
    }
    
    [self addChild:theCharacter.sprite z:1000 - theCharacter.position.y];
}

-(void) addBarrier:(Barrier *)theBarrier
{
    [barriers addObject:theBarrier];
    [self addChild:theBarrier z:1000 - theBarrier.center.y];
}

-(void)removeCharacter:(Character *)character
{
    [characters removeObject:character];
}

-(void) setMap:(CCSprite*)theMap
{
    mapBody = theMap;
    [cameraControl setMap:theMap mapLayer:self];
    
    [self addChild:cameraControl];
    [self addChild:mapBody z:0];
    CCLOG(@"MAPSIZE X:%f Y:%f", mapBody.boundingBox.size.width, mapBody.boundingBox.size.height);
}

-(void) setMapBlocks
{
    for( int x=0; x<128; x++ )
    {
        for( int y=0; y<53; y++)
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

-(void) moveCharacterTo:(Character*)theCharacter position:(CGPoint)location
{
    //int x = (location.x + mapBody.boundingBox.size.width/2)/10;
    //int y = (location.y + mapBody.boundingBox.size.height/2)/10;
    
    float moveX = location.x;
    float moveY = location.y;
    
//    CCLOG(@"PLAYER BLOCK x:%i y:%i", x, y);
    
    // Character Collide with Character
    for( int i=0; i<characters.count; i++ )
    {
        if( [characters objectAtIndex:i] == theCharacter )
        {
            continue;
        }
        
        CGPoint targetLocation = [[characters objectAtIndex:i] position];
        CGPoint selfLocation = theCharacter.position;
        
        float targetRadius = [[characters objectAtIndex:i] sprite].boundingBox.size.width/2;
        float selfRadius = theCharacter.sprite.boundingBox.size.width/2;
        
        // redirect the location
        if( ccpDistance(targetLocation, location ) < (targetRadius + selfRadius ) )
        {
            CGPoint redirect = [Helper moveRedirectWhileCollisionP1:selfLocation R1:selfRadius P2:targetLocation R2:targetRadius Location:location];
            
            moveX = redirect.x;
            moveY = redirect.y;
        }
        // redirect the location
    }
    // Character Collide with Character
    
    // Character Collide with Barriers
    for( int i=0; i<barriers.count; i++ )
    {
        CGPoint targetLocation = [[barriers objectAtIndex:i] center];
        CGPoint selfLocation = theCharacter.position;
        
        float targetRadius = [[barriers objectAtIndex:i] radius];
        float selfRadius = theCharacter.sprite.boundingBox.size.width/2;
        
        // redirect the location
        if( ccpDistance(targetLocation, location ) < (targetRadius + selfRadius ) )
        {
            CGPoint redirect = [Helper moveRedirectWhileCollisionP1:selfLocation R1:selfRadius P2:targetLocation R2:targetRadius Location:location];
            
            moveX = redirect.x;
            moveY = redirect.y;
        }
        // redirect the location
    }
    // Character Collide with Barriers

    
    // MAP LIMIT
    float mapXLimit = mapBody.boundingBox.size.width/2;
    float mapYLimit = mapBody.boundingBox.size.height/2;
    float characterWidth = theCharacter.sprite.boundingBox.size.width/2;
    
    moveX = MIN( MAX( moveX, -1*mapXLimit + characterWidth ), mapXLimit - characterWidth);
    moveY = MIN( MAX( moveY, -1*mapYLimit + characterWidth ), mapYLimit - characterWidth);
    // MAP LIMIT END
//    CCLOG(@"LIMITS X:%f Y:%f", mapXLimit, mapYLimit);
//    CCLOG(@"CHARA POSITION X:%f Y:%f", theCharacter.position.x, theCharacter.position.y);
    
    [self reorderChild:theCharacter.sprite z: 1000 - moveY];
    
    theCharacter.position = ccp(moveX,moveY);
}

-(void) moveCharacter:(Character*)theCharacter withVelocity:(CGPoint)velocity
{
    [self moveCharacterTo:theCharacter position:ccpAdd(theCharacter.position, velocity)];
    // TODO: Give the final velocity to character.
    // The best way is return a final velocity, and let the |setCharacterWithVelocity| out of here.
    [theCharacter setCharacterWithVelocity:velocity];
}



-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    [cameraControl followTarget:NULL];
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint lastPoint = [touch previousLocationInView:touch.view];
    lastPoint = [[CCDirector sharedDirector] convertToGL:lastPoint];
    
    
    
    
    CGPoint diff = ccp( location.x - lastPoint.x, location.y - lastPoint.y );
    [cameraControl moveCameraX:-0.5*diff.x Y:-0.5*diff.y];
    
}

@end
