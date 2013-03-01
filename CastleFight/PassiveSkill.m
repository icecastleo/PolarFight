//
//  PassiveSkill.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/29.
//
//

#import "PassiveSkill.h"
#import "Character.h"

@implementation PassiveSkill

static const float interval = kPassiveSkillInterval;

-(void)setCharacter:(Character *)character {
    _character = character;
    
    if (_duration > 0) {
        [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(update:) userInfo:nil repeats:YES];
    }
}

-(void)update:(NSTimer *)timer {
    _duration -= interval;
    
    if (_duration <= 0) {
        [timer invalidate];
        [_character removePassiveSkill:self];
    }
}

@end
