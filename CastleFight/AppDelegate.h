//
//  AppDelegate.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/22.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "Flurry.h"
@interface AppController : NSObject <UIApplicationDelegate, CCDirectorDelegate>
{
	UIWindow *window_;
	UINavigationController *navController_;

	CCDirectorIOS	*__unsafe_unretained director_;							// weak ref
}

@property (nonatomic, strong) UIWindow *window;
@property (readonly) UINavigationController *navController;
@property (unsafe_unretained, readonly) CCDirectorIOS *director;

@end
