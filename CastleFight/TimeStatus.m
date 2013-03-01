//
//  TimeStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "TimeStatus.h"
#import "Character.h"

// Any concrete child of AuraStatus should implement -(id)initWithTime:(int)t toCharacter:(Character*)cha;
@implementation TimeStatus
@synthesize time;

-(id) initWithType:(TimeStatusType)statusType withTime:(int)t toCharacter:(Character*)cha {
    if(self = [super initWithType:statusType]) {
        time = t;
        character = cha;
        [self addEffect];
    }
    return self;
}

-(void)addEffect {
//    [NSException raise:@"Called abstract method!" format:@"You should override addEffect in CharacterStatus."];
}

-(void)removeEffect {
//    [NSException raise:@"Called abstract method!" format:@"You should override removeEffect in CharacterStatus."];
}

-(void)addTime:(int)t {
    time += t;
}

-(void)minusTime:(int)t {
    time -= t;

    if (time <= 0) {
        [self removeEffect];
        isDead = YES;
    }
}

-(void)update {
    [self minusTime:1];
}

@end
