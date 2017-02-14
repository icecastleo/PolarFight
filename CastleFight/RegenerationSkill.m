//
//  RegenerationSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/12.
//
//

#import "RegenerationSkill.h"
#import "Character.h"

@implementation RegenerationSkill

-(id)initWithPercentValue:(int)aValue {
    if(self = [super init]) {
        percentValue = aValue / 100.0;
    }
    return self;
}

-(void)characterDidRoundEnd:(Character *)sender {
    int healValue = (percentValue * [sender getAttribute:kCharacterAttributeHp].value);
    [sender getHeal:healValue];
}


@end
