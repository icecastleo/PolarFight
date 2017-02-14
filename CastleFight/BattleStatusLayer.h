//
//  StatusLayer.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/10/31.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "BattleController.h"
#import "PlayerComponent.h"

@interface BattleStatusLayer : CCLayer

-(id)initWithBattleController:(BattleController *)controller;
-(void)update:(ccTime)delta;

-(void)displayString:(NSString *)string withColor:(ccColor3B)color;

@end
