//
//  AttackDelegateSkill.m
//  CastleFight
//
//  Created by 朱 世光 on 13/3/11.
//
//

#import "AttackDelegateSkill.h"
#import "AttackEvent.h"
#import "Character.h"

@implementation AttackDelegateSkill

-(void)effectTarget:(Character *)target atPosition:(CGPoint)position {
    AttackEvent *event = [[AttackEvent alloc] initWithAttacker:character attackType:kAttackNoraml defender:target];
    event.position = position;
    [target receiveAttackEvent:event];
}

@end
