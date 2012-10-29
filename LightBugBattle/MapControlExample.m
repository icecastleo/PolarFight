//
//  MapControlExample.m
//  LightBugBattle
//
//  Created by Huang Hsing on 12/10/29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MapControlExample.h"


@implementation MapControlExample

+(CCScene*) scene
{
	CCScene *scene = [CCScene node];
	
	MapControlExample *layer = [MapControlExample node];

	[scene addChild: layer];

	return scene;
}

-(id) init
{

	if( (self=[super init]) ) {
		
        CGSize size = [CCDirector sharedDirector].winSize;
        
        //CameraControl Init
        camControl = [MapCameraControl node];
        
        
        //first you need a MAP and a layer to put MAP
        //*CCNode can be a layer
        CCNode* layerMap = [CCNode node];
        CCSprite* map = [CCSprite spriteWithFile:@"map.png"];
        
        
        //some map setting
        [map setScale:2];
        [map setPosition:ccp(0,0)];
        
        
        //the camera need to be add into the map layer
        //(it wont display but not adding it will cause error)
        [layerMap addChild:camControl];
        [layerMap addChild:map];
        
        
        //Set map and layer to CameraControl
        [camControl setMap:map mapLayer:layerMap];
        
        
        
        
        //Some setting for testing the CameraControl
        moveMap = false;
        
        switchButton = [CCSprite spriteWithFile:@"Icon-72.png"];
        movePanel = [CCSprite spriteWithFile:@"controlBall.png"];
        moveButton = [CCSprite spriteWithFile:@"controlBall.png"];
        
        movePanel.scale = 0.3;
        moveButton.scale = 0.1;
        
        [switchButton setPosition:ccp(size.width - switchButton.boundingBox.size.width/2, 40)];
        [movePanel setPosition:ccp(movePanel.boundingBox.size.width/2,movePanel.boundingBox.size.width/2)];
        [moveButton setPosition:ccp( movePanel.position.x, movePanel.position.y)];
        
        man1 = [CCSprite spriteWithFile:@"amg1_fr2.gif"];
        man2 = [CCSprite spriteWithFile:@"ftr1_fr1.gif"];
        man3 = [CCSprite spriteWithFile:@"avt4_fr1.gif"];
        
        [layerMap addChild:man1];
        [layerMap addChild:man2];
        [layerMap addChild:man3];
        
        [man1 setPosition:ccp( 0, 100)];
        [man2 setPosition:ccp( -100, 0)];
        [man3 setPosition:ccp( -300,100)];
        
        
        [self addChild:layerMap];
        [self addChild:movePanel];
        [self addChild:moveButton];
        [self addChild:switchButton];
        
        [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:YES];
        
	}
	return self;
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    moveMan = false;
    moveMap = false;
    if( CGRectContainsPoint(switchButton.boundingBox, location))
    {
        float temp = CCRANDOM_0_1();
        
        if( temp < 0.3 )
        {
            moveTarget = man1;
            [camControl followTarget:man1];
        }
        else if( temp < 0.6)
        {
            moveTarget = man2;
            [camControl followTarget:man2];
        }
        else
        {
            moveTarget = man3;
            [camControl followTarget:man3];
        }
        
        return YES;
    }
    else if( CGRectContainsPoint(movePanel.boundingBox, location))
    {
        moveMan = YES;
        return YES;
    }
    moveMap = true;
    [camControl followTarget:NULL];
    return YES;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    CGPoint location = [touch locationInView:touch.view];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    CGPoint lastPoint = [touch previousLocationInView:touch.view];
    lastPoint = [[CCDirector sharedDirector] convertToGL:lastPoint];
    
    
    
    if( moveMan )
    {
        if( CGRectContainsPoint(movePanel.boundingBox, location))
        {
            [moveButton setPosition:location];
        }
        moveAmount = ccp( moveButton.position.x-movePanel.position.x, moveButton.position.y-movePanel.position.y );
        [self schedule:@selector(moveUpdate:)];
    }
    else if( moveMap )
    {
        CGPoint diff = ccp( location.x - lastPoint.x, location.y - lastPoint.y );
        [camControl moveCameraX:-0.5*diff.x Y:-0.5*diff.y];
    }
    else
    {
        return ;
    }
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    [moveButton setPosition:movePanel.position];
    [self unschedule:@selector(moveUpdate:)];
}
-(void) moveUpdate:(ccTime) dt
{
    [moveTarget setPosition:ccpAdd(moveTarget.position, ccp(moveAmount.x*dt, moveAmount.y*dt ) )];
}

@end
