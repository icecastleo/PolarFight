//
//  AuraStatus.m
//  LightBugBattle
//
//  Created by 朱 世光 on 12/11/6.
//
//

#import "AuraStatus.h"
#import "Character.h"

@implementation AuraStatus

-(id)initWithType:(AuraStatusType)statusType withRange:(Range*)rangeType {
    if(self = [super initWithType:statusType]) {
        range = rangeType;
    }
    return self;
}

//// caster might not need, just for information
//-(id)initWithCharacter:(Character *)cha caster:(Character *)cas {
//    if(self = [super init]) {
//        NSAssert(range != nil, @"You should init range while extend AuraStatus!!");
//        caster = cas;
//        [self addEffect];
//    }
//    return self;
//}

-(void)addEffectOnCharacter:(Character *)character {
    
}

-(void)removeEffectOnCharacter:(Character *)character {
    
}

-(void)updateCharacter:(Character *)character {
    // character is out of range
    if (![range containTarget:character]) {
        [self removeEffectOnCharacter:character];
        isDead = YES;
    }
}

@end
