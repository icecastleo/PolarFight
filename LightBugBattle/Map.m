//
//  Map.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/11/2.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Map.h"


@implementation Map

@synthesize cameraControl;

-(id) init
{
    if((self=[super init]))
    {
        cameraControl = [MapCameraControl node];
        characters = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void) setMap:(CCSprite*)theMap
{
    mapBody = theMap;
    [cameraControl setMap:theMap mapLayer:self];
    
    [self addChild:cameraControl];
    [self addChild:mapBody];
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

-(void) addCharacter:(CCSprite*) theCharacter position:(CGPoint)location
{
    [characters addObject:theCharacter];
    [theCharacter setPosition:location];
    [self addChild:theCharacter];
}

-(void) moveCharacterTo:(CCSprite*)theCharacter position:(CGPoint)location
{
    int x = (location.x + mapBody.boundingBox.size.width/2)/10;
    int y = (location.y + mapBody.boundingBox.size.height/2)/10;
    
    float moveX = location.x;
    float moveY = location.y;
    
    CCLOG(@"PLAYER BLOCK x:%i y:%i", x, y);
    
    for( int i=0; i<characters.count; i++ )
    {
        if( [characters objectAtIndex:i] == theCharacter )
        {
            continue;
        }
        CGPoint targetLocation = [[characters objectAtIndex:i] position];
        
        if( ccpDistance(location, targetLocation) < theCharacter.boundingBox.size.width)
        {
            moveX = theCharacter.position.x;
            moveY = theCharacter.position.y;
        }
    }
    
    [theCharacter setPosition:ccp(moveX,moveY)];
}

-(void) moveCharacter:(CCSprite*)theCharacter velocity:(CGPoint)amount
{
    [self moveCharacterTo:theCharacter position:ccpAdd(theCharacter.position, amount)];
    //[theCharacter setPosition:ccpAdd(theCharacter.position, amount)];
}

-(void) dealloc
{
    [characters release];
    [super dealloc];
}
@end
