//
//  EffectDamage.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "EffectDamage.h"
#import "BattleSprite.h"

@implementation EffectDamage


-(void) doEffect:(BattleSprite *)actor
{
    [actor getDamage:6];
}
@end
