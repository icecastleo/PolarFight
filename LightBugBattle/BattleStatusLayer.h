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

@interface BattleStatusLayer : CCLayer {
//    BattleController *controller;
    
    CCLabelTTF *__unsafe_unretained startLabel;
    CCLabelBMFont *countdownLabel;
    
    CCSprite *selectSprite;
    CCAction *selectAction;
}

@property (unsafe_unretained, readonly) CCLabelTTF *startLabel;
@property (readonly) CCLabelBMFont *countdownLabel;

-(id) initWithBattleController:(BattleController*) controller;
//-(void) update:(ccTime) delta;

-(void) startSelectCharacter:(Character*)character;
-(void) stopSelect;

@end
