//
//  RegenerationSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/12/12.
//
//

#import "PassiveSkill.h"

@interface RegenerationSkill : PassiveSkill {
    int value;
}

-(id)initWithValue:(int)aValue;

@end
