//
//  BattleLayer.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedJoystickExample.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"

@interface BattleLayer : CCLayer {
    
    SneakyJoystick *leftJoystick;
    SneakyButton *attackButton;
    
    CCSprite *currentSprite;
}

+(id) scene;

@end
