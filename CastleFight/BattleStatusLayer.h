//
//  StatusLayer.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BattleController.h"

@class CharacterQueue;

@interface BattleStatusLayer : CCLayer {
//    BattleController *controller;
}

-(id)initWithBattleController:(BattleController *)controller;
-(void)displayString:(NSString *)string withColor:(ccColor3B)color;

@end
