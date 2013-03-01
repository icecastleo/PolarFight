//
//  EffectTimeStatus.h
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/18.
//
//

#import "Effect.h"
#import "TimeStatus.h"

@interface TimeStatusEffect : Effect {
    TimeStatusType type;
    int time;
}

+(id)statusWithType:(TimeStatusType)statusType withTime:(int)t;
-(id)initWithType:(TimeStatusType)statusType withTime:(int)t;

@end
