//
//  BigPillowBomb.m
//  CastleFight
//
//  Created by  浩翔 on 13/5/27.
//
//

#import "BigPillowBomb.h"
#import "DamageEvent.h"
#import "AttackEvent.h"

@implementation BigPillowBomb

-(void)sideEffectWithEvent:(AttackEvent *)event Entity:(Entity *)entity {
    if(30 > (arc4random() % 100)){
        event.isCustomDamage = YES;
        event.customDamage = event.attack.attack.value * 3;
    }
}

@end
