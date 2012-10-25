//
//  BattleLayer.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/22.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BattleSprite.h"

#import "SneakyJoystick.h"
#import "SneakyJoystickSkinnedJoystickExample.h"
#import "SneakyJoystickSkinnedDPadExample.h"
#import "SneakyButton.h"
#import "SneakyButtonSkinnedBase.h"
#import "ColoredCircleSprite.h"

@interface BattleLayer : CCLayer {
    
    SneakyJoystick *leftJoystick;
    SneakyButton *attackButton;
    
    BattleSprite *currentSprite;
    NSMutableArray *sprites;
    
    bool canMove;
    bool isMove;
    float cumulativeTime;
    
    int currentIndex;
    
    CCLabelTTF *startLabel;
    
    CCSprite *selectSprite;
    CCAction *selectAction;
}

+(id) scene;

@end
