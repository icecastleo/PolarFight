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

-(id)initWithBonusPercent:(int)aPercent {
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
        event.bonus += percent / 100.0 * time * [sender getAttribute:kCharacterAttributeAttack].value;
    }
}

@end
