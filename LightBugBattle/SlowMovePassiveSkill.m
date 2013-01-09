//
//  SlowMoveSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "SlowMovePassiveSkill.h"
#import "Character.h"
#import "Attribute.h"

@implementation SlowMovePassiveSkill

-(void)characterWillAddDelegate:(Character *)sender {
    [[sender getAttribute:kCharacterAttributeSpeed] addMultiplier:0.5];
}

-(void)characterWillRemoveDelegate:(Character *)sender {
    [[sender getAttribute:kCharacterAttributeSpeed] subtractMultiplier:0.5];
}

@end
