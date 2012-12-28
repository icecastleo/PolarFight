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

-(id)initWithValue:(int)aValue {
    if(self = [super init]) {
        value = aValue;
    }
    return self;
}

-(void)characterDidRoundEnd:(Character *)sender {
    [sender getHeal:value];
}


@end
