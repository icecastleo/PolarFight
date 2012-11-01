//
//  EffectDamage.m
//  LightBugBattle
//
//  Created by 陳 謙 on 12/10/30.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "EffectDamage.h"
#import "Character.h"

@implementation EffectDamage


-(void) doEffect:(Character *)character
{
    [character getDamage:6];
}
@end
