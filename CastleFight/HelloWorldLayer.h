//
//  HelloWorldLayer.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameCenterManager.h"
// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GameCenterManagerDelegate> {
}

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;
 
@end
