//
//  PoisonStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "PoisonStatus.h"

@implementation PoisonStatus

-(void)update {
    [character getDamage:character.maxHp / 5];
    [super update];
}

@end
