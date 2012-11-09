//
//  AuraStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "AuraStatus.h"
#import "SkillKit.h"

@implementation AuraStatus

// caster might not need, just for information
-(id)initWithCharacter:(Character *)cha caster:(Character *)cas {
    if(self = [super initWithCharacter:cha]) {
        NSAssert(range != nil, @"You should init range while extend AuraStatus!!");
        caster = cas;
        [self addEffect];
    }
    return self;
}

-(void)update {
    // character is out of range
    if (![range containTarget:character]) {
        [self removeEffect];
    }
}

@end
