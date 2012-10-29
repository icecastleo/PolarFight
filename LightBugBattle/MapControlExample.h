//
//  MapControlExample.h
//  LightBugBattle
//
//  Created by Huang Hsing on 12/10/29.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "MapCameraControl.h"

@interface MapControlExample : CCLayer
{
    MapCameraControl* camControl;
    
    
    //things to test the camera control
    CCSprite* switchButton;
    CCSprite* movePanel;
    CCSprite* moveButton;
    CCSprite* man1;
    CCSprite* man2;
    CCSprite* man3;
    BOOL moveMap;
    BOOL moveMan;
    CCSprite* moveTarget;
    CGPoint moveAmount;
    
}

+(CCScene*) scene;
@end
