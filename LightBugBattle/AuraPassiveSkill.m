//
//  AuraPassiveSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 13/1/7.
//
//

#import "AuraPassiveSkill.h"
#import "Character.h"

@implementation AuraPassiveSkill

-(id)initWithCharacter:(Character *)aCharacter {
    if (self = [super init]) {
        character = aCharacter;
        _remainTime = kAuraInterval + kAuraPassiveInterval;
        [NSTimer scheduledTimerWithTimeInterval:kAuraPassiveInterval target:self selector:@selector(update:) userInfo:nil repeats:YES];
    }
    return self;
}

-(void)update:(NSTimer *)timer {    
    _remainTime -= kAuraPassiveInterval;
    
    if (_remainTime <= 0) {
        [timer invalidate];
        [character.auraPassiveSkillDictionary removeObjectForKey:NSStringFromClass(self.class)];
    }
}

@end
