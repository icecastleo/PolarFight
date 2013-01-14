//
//  TestSkill.h
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/14.
//
//


#import "ActiveSkill.h"

@class RangeCarrier;

@interface TestSkill : ActiveSkill
-(void)delayExecute:(NSMutableArray *) target carrier:(RangeCarrier*) carrier;

@end
