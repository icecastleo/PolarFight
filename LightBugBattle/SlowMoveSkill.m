//
//  SlowMoveSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "SlowMoveSkill.h"
#import "Character.h"
#import "Attribute.h"

@implementation SlowMoveSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super initWithCharacter:aCharacter]) {
        [[character getAttribute:kCharacterAttributeSpeed] addMultiplier:0.5];
    }
    return self;
}

-(void)dealloc {
    if (character != nil) {
        [[character getAttribute:kCharacterAttributeSpeed] subtractMultiplier:0.5];
    }
}

@end
