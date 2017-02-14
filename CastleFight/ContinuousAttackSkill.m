//
//  ContinuousAttackSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/27.
//
//

#import "ContinuousAttackSkill.h"
#import "Character.h"

@implementation ContinuousAttackSkill

-(id)initWithPercent:(int)aPercent {
    if(self = [super init]) {
        percent = aPercent;
    }
    return self;
}

-(void)character:(Character *)sender willSendAttackEvent:(AttackEvent *)event {
    if (previousTarget != event.defender) {
        previousTarget = event.defender;
        time = 0;
    } else {
        time ++;
        [event addAttack: percent / 100.0 * time * event.attack];
    }
}

@end
